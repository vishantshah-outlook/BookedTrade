({
    //ON INIT GET THE DATATABLE COLUMNS AND DATA TO DISPLAY
    init: function (component, event, helper) {
        helper.getColumns(component);
        helper.getData(component);
    },

    //HANDLE SORTING OF ROWS IN DATATABLE
    handleSort: function (component, event, helper) {
        helper.handleSort(component, event);
    },

    //SHOW MODAL WINDOW WHEN USER PRESSES THE "NEW" BUTTON
    handleShowModal: function (component, evt, helper) {
        let modalBody;
        $A.createComponent("c:AddBookedTrade", {},
            function (content, status) {
                if (status === "SUCCESS") {
                    modalBody = content;
                    component.find('overlayLib').showCustomModal({
                        header: "New Trade",
                        body: modalBody,
                        showCloseButton: false,
                        closeCallback: function () {
                            // CALLBACK HANDLER TO REFRESH THE DATA GRID.
                            helper.getData(component);
                        }
                    })
                }
            }
        );
    }
});