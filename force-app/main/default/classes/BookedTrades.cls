//CLASS TO SUPPORT UI FUNCTIONS FOR BookedTrades
public with sharing class BookedTrades {

    public static final String DATATABLE_BOOKED_TRADES = 'Booked_Trades';

    //GET DATATABLE FROM Utility CLASS FOR Booked Trades
    @AuraEnabled
    public static Object getDatatableStructure() {
        return Utility.getLightningDatatable(DATATABLE_BOOKED_TRADES);
    }

    //GET CURRENCIES FROM Fixer API
    @AuraEnabled
    public static Object getCurrencies() {
        try {
            Map<String, Object> currencyData = (Map<String, Object>) JSON.deserializeUntyped(Utility.getFixerAPIData(Settings.FIXER_SYMBOLS_API));
            Map<String, Object> currencies = (Map<String, Object>) currencyData.get('symbols');

            List<Map<String, String>> currencyPicklist = new List<Map<String, String>>();
            for (String option : currencies.keySet()) {
                currencyPicklist.add(new Map<String, String>{
                        'option' => option, 'label' => option + ' - ' + (String) currencies.get(option)
                });
            }

            return currencyPicklist;
        } catch (Exception ex) {
            return new Map<String, String>{
                    'failed' => 'Unable to get currencies, Please ask support from Admins'
            };
        }
    }

    //GET Rate FOR CURRENCY PASSED FROM LIGHTNING COMPONENT
    @AuraEnabled
    public static Object getRate(String currencyToGet) {
        try {
            Map<String, Object> ratesData = (Map<String, Object>) JSON.deserializeUntyped(Utility.getFixerAPIData(Settings.FIXER_LATEST_API));
            Map<String, Object> currencies = (Map<String, Object>) ratesData.get('rates');

            return currencies.get(currencyToGet);
        } catch (Exception ex) {
            return new Map<String, String>{
                    'failed' => 'Unable to get Rate for ' + currencyToGet + ', Please ask support from Admins'
            };
        }
    }

    //GET ALL BOOKED TRADES TO SHOW ON UI
    @AuraEnabled
    public static List<Booked_Trade__c> getBookedTrades() {
        return [
                SELECT Id, Trade_Id__c, Sell_Amount__c, Sell_Currency__c, Buy_Amount__c, Buy_Currency__c, Rate_Booked__c, CreatedDate
                FROM Booked_Trade__c
                ORDER BY CreatedDate DESC
        ];
    }

    //CREATE A NEW BOOKED TRADE RECORD.
    @AuraEnabled
    public static Object createTrade(Decimal rateBooked, Decimal sellAmount, String sellCurrency, Decimal buyAmount, String buyCurrency) {
        Database.SaveResult saveResults;
        try {
            Booked_Trade__c bt = new Booked_Trade__c();
            bt.Rate_Booked__c = rateBooked;
            bt.Sell_Amount__c = sellAmount;
            bt.Sell_Currency__c = sellCurrency;
            bt.Buy_Currency__c = buyCurrency;
            bt.Buy_Amount__c = buyAmount;

            saveResults = Database.insert(bt);
            return bt;
        } catch (Exception ex) {
            return new Map<String, String>{
                    'failed' => saveResults.getErrors()[0].getMessage()
            };
        }
    }
}