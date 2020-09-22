@IsTest
public class BookedTradesTriggerHandlerTest {

    //METHOD TO TEST BOOKED TRADE INSERTION
    @IsTest
    static void testBookedTradeInsertion() {
        List<Booked_Trade__c> bookedTrades = new List<Booked_Trade__c>();

        for (Integer counter = 1; counter < 200; counter++) {
            bookedTrades.add(createBookedTrade(counter));
        }

        Test.startTest();

        insert bookedTrades;

        for (Booked_Trade__c bt : [SELECT Sell_Amount__c, Sell_Currency__c, Rate_Booked__c, Trade_Id__c, Buy_Amount__c, Buy_Currency__c FROM Booked_Trade__c]) {
            System.assertEquals(3, bt.Sell_Currency__c.length(), 'Sell Currency length should be 3');
            System.assertEquals(3, bt.Buy_Currency__c.length(), 'Buy Currency length should be 3');
            System.assertEquals(bt.Sell_Amount__c * bt.Rate_Booked__c, bt.Buy_Amount__c, 'Buy Amount should be Sell Amount * Rate Booked');
            System.assert(bt.Trade_Id__c.startsWith('TR'), 'Booked Trade Id should start with TR');
            System.assertEquals(9, bt.Trade_Id__c.length(), 'Booked Trade Id length should be 9');
        }

        // CANT REALLY TEST THE POST ON CHATTER FEEDS, CHECKING HOW MANY ARE IN THE LIST INSTEAD.
        System.assertEquals(bookedTrades.size() * BookedTradesTriggerHandler.groupMembers.size(), BookedTradesTriggerHandler.batchInputs.size(), 'there should be similar number of chatter posts to create');

        Test.stopTest();
    }

    //METHOD TO CREATE A BOOKED TRADE FOR TEST
    public static Booked_Trade__c createBookedTrade(Integer counter) {
        Booked_Trade__c bt = new Booked_Trade__c();
        bt.Sell_Currency__c = getRandomCurrency();
        bt.Buy_Currency__c = getRandomCurrency();
        bt.Sell_Amount__c = counter;
        bt.Rate_Booked__c = Integer.valueOf((Math.random() * 10));
        bt.Buy_Amount__c = bt.Sell_Amount__c * bt.Rate_Booked__c;

        return bt;
    }

    //METHOD TO RETURN A RANDOM CURRENCY VALUE
    public static String getRandomCurrency() {
        List<String> availableValues = new List<String>{
                'USD', 'GBP', 'INR', 'ALL', 'YEN'
        };
        Integer listSize = availableValues.size() - 1;
        Integer randomNumber = Integer.valueOf((Math.random() * listSize));
        return availableValues[randomNumber];
    }

    @TestSetup
    private static void setupData() {
        //Creating Group
        Group testGroup = new Group(Name = Settings.QUEUE_TRADE_REVIEWERS, Type = 'Queue');
        insert testGroup;
		Id userId = UserInfo.getUserId();
        System.runAs(new User(Id = UserInfo.getUserId())) {
            QueueSobject testQueue = new QueueSobject(QueueId = testGroup.Id, SobjectType = 'Booked_Trade__c');
            insert testQueue;
            
            GroupMember member = new GroupMember();
            member.UserOrGroupId = userId;
            member.GroupId = testGroup.Id;
            insert member;
        }
    }
}