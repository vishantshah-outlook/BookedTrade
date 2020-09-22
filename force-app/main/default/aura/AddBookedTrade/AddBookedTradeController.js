({
    //ON INIT, GET THE CURRENCIES FROM fixer API AND SHOW IN BUY AND SELL CURRENCY PICKLIST FIELDS
    init: function (component, event, helper) {
        helper.getCurrency(component, helper);
    },

    //HANDLE WHEN SELL CURRENCY IS CHANGED
    sellCurrencyChanged: function (component, event, helper) {
        let selectedSellCurrency = component.get('v.sellCurrency');
        if (selectedSellCurrency !== 'EUR') {
            helper.showToast(component, 'Error', 'Due to API limitations, Sell Currency can only be set to "EUR"', "error");
        }
    },

    //HANDLE WHEN BUY CURRENCY IUS CHANGED
    buyCurrencyChanged: function (component, event, helper) {
        let selectedBuyCurrency = component.get('v.buyCurrency');
        let selectedSellCurrency = component.get('v.sellCurrency');

        if (selectedBuyCurrency && selectedSellCurrency) {
            helper.getRates(component, helper, selectedBuyCurrency);
        } else {
            component.set('v.sellRate', null);
        }
    },

    //HANDLE WHEN SELL AMOUNT IS CHANGED
    sellAmountChanged: function (component, event, helper) {
        helper.setBuyAmount(component, helper);
    },

    //HANDLE CLICK OF CANCEL BUTTON
    handleCancel: function (component, event, helper) {
        component.find("overlayLib").notifyClose();
    },

    //HANDLE CLICK OF CREATE BUTTON
    handleCreate: function (component, event, helper) {
        helper.createTrade(component, event, helper);
    }
});