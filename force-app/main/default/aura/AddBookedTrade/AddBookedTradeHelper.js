({
    //GET LIST OF CURRENCIES VIA APEX FROM fixer API TO SHOW IN BUY AND SELL PICKLISTS
    getCurrency: function (component, helper) {
        let action = component.get("c.getCurrencies");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                if (!response.getReturnValue().failed) {
                    component.set('v.currencyOptions', response.getReturnValue());
                } else {
                    helper.showToast(component, 'Error', response.getReturnValue().failed, 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },

    //GET RATE WHEN SELL CURRENCY IS SET AND BUY CURRENCY IS SET
    getRates: function (component, helper, selectedBuyCurrency) {
        let action = component.get("c.getRate");
        action.setParams({currencyToGet: selectedBuyCurrency});
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                if (!response.getReturnValue().failed) {
                    component.set('v.sellRate', response.getReturnValue());
                    helper.setBuyAmount(component, helper);
                } else {
                    helper.showToast(component, 'Error', response.getReturnValue().failed, 'error');
                }
            }
        });
        $A.enqueueAction(action);
    },

    //SET BUY AMOUNT WHEN SELL AMOUNT IS ENTERED
    setBuyAmount: function (component, helper) {
        let sellAmount = component.get('v.sellAmount');
        let sellRate = component.get('v.sellRate');

        component.set('v.buyAmount', sellAmount * sellRate);
    },

    //SHOW MESSAGE POST ACTIONS
    showToast: function (component, success, message, type) {
        let toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": success,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    //CREATE A TRADE VIA APEX
    createTrade: function (component, event, helper) {
        let action = component.get("c.createTrade");

        action.setParams({
            rateBooked: component.get('v.sellRate'),
            sellAmount: component.get('v.sellAmount'),
            sellCurrency: component.get('v.sellCurrency'),
            buyAmount: component.get('v.buyAmount'),
            buyCurrency: component.get('v.buyCurrency')
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            let responseVal = response.getReturnValue();
            if (state === 'SUCCESS' && responseVal.Id) {
                if (!response.getReturnValue().failed) {
                    helper.showToast(component, 'Success', 'Trade Created', 'success');
                    component.find("overlayLib").notifyClose();
                } else {
                    helper.showToast(component, 'Error', response.getReturnValue().failed, 'error');
                }
            } else {
                helper.showToast(component, 'Error', responseVal, 'error');
            }
        });
        $A.enqueueAction(action);
    }
});