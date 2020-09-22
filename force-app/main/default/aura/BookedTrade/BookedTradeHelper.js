({

    //GET COLUMNS VIA APEX AND PUSH TO COMPONENT
    getColumns: function (component) {
        let action = component.get("c.getDatatableStructure");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.columns', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    //GET DATA VIA APEX AND PUSH TO COMPONENT
    getData: function (component) {
        let action = component.get("c.getBookedTrades");
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                component.set('v.data', response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    //SORT FIELD AND DIRECTION
    sortBy: function (field, reverse, primer) {
        let key = primer
            ? function (x) {
                return primer(x[field]);
            }
            : function (x) {
                return x[field];
            };

        return function (a, b) {
            a = key(a);
            b = key(b);
            return reverse * ((a > b) - (b > a));
        };
    },

    //HANDLE SORT
    handleSort: function (component, event) {
        let sortedBy = event.getParam('fieldName');
        let sortDirection = event.getParam('sortDirection');
        let originalData = component.get('v.data');

        let cloneData = originalData.slice(0);
        cloneData.sort((this.sortBy(sortedBy, sortDirection === 'asc' ? 1 : -1)));

        component.set('v.data', cloneData);
        component.set('v.sortDirection', sortDirection);
        component.set('v.sortedBy', sortedBy);
    }
})