@IsTest
private class BookedTradesTest {

    //TEST TO CHECK OUTPUT OF DATATABLE LIST AND ASSERT NUMBER OF COLUMNS
    @IsTest
    static void testGetBookedTradeLightningDatatable() {
        List<Object> dataTable = (List<Object>) BookedTrades.getDatatableStructure();
        System.assertEquals(6, dataTable.size(), 'There should be 6 columns in datatable');
    }

    //TEST TO GET CURRENCIES USING MOCK CLASS BELOW
    @IsTest
    static void testGetCurrencies() {
        Test.setMock(HttpCalloutMock.class, new Mock());

        Test.startTest();

        List<Map<String, String>> currencies = (List<Map<String, String>>) BookedTrades.getCurrencies();
        System.assertEquals(4, currencies.size(), 'There should be 4 currencies returned');

        Test.stopTest();
    }

    //TEST TO GET RATE USING MOCK CLASS BELOW
    @IsTest
    static void testGetRates() {
        Test.setMock(HttpCalloutMock.class, new Mock());

        Test.startTest();

        Decimal rate = (Decimal) BookedTrades.getRate('AED');
        System.assertEquals(4.350666, rate, 'Rate should be 4.350666');

        Test.stopTest();
    }

    //TEST INSERTION OF BOOKED TRADE.
    @IsTest
    static void testBookedTradeInsertAndGet() {
        Test.startTest();
        Decimal bookedRate = Integer.valueOf((Math.random() * 10));
        BookedTrades.createTrade(bookedRate,
                123,
                BookedTradesTriggerHandlerTest.getRandomCurrency(),
                123 * bookedRate,
                BookedTradesTriggerHandlerTest.getRandomCurrency());


        for (Booked_Trade__c bt : BookedTrades.getBookedTrades()) {
            System.assertEquals(3, bt.Sell_Currency__c.length(), 'Sell Currency length should be 3');
            System.assertEquals(3, bt.Buy_Currency__c.length(), 'Buy Currency length should be 3');
            System.assertEquals(bt.Sell_Amount__c * bt.Rate_Booked__c, bt.Buy_Amount__c, 'Buy Amount should be Sell Amount * Rate Booked');
            System.assert(bt.Trade_Id__c.startsWith('TR'), 'Booked Trade Id should start with TR');
            System.assertEquals(9, bt.Trade_Id__c.length(), 'Booked Trade Id length should be 9');
        }

        Test.stopTest();
    }

    //MOCK CLASS TO TEST API CALLOUTS.
    private class Mock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest req) {

            HttpResponse res = new HttpResponse();

            if (req.getEndpoint() == Settings.FIXER_SYMBOLS_API) {
                res.setBody('{"success":true,"symbols":{"EUR":"Euro","INR":"Indian Rupee","GBP":"British Pound Sterling","USD":"United States Dollar"}}');
                res.setStatusCode(200);
            } else if (req.getEndpoint() == Settings.FIXER_LATEST_API) {
                res.setBody('{"success":true,"timestamp":1600461544,"base":"EUR","date":"2020-09-18","rates":{"AED":4.350666,"AFN":91.002923,"ALL":123.963391}}');
                res.setStatusCode(200);
            }

            return res;
        }

    }

    //SETUP INITIAL DATA.
    @TestSetup
    static void setupData() {
        List<Booked_Trade__c> bookedTrades = new List<Booked_Trade__c>();
        for (Integer counter = 1; counter < 200; counter++) {
            bookedTrades.add(BookedTradesTriggerHandlerTest.createBookedTrade(counter));
        }
        insert bookedTrades;
    }
}