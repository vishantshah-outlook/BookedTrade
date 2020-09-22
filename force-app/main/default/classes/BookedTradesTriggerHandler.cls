//SINGLETON CLASS TO HANDLE TRIGGER LOGIC FOR Booked_Trade__c
public with sharing class BookedTradesTriggerHandler {

    private static BookedTradesTriggerHandler instance;
    private static List<Group> queue;
    @TestVisible private static List<GroupMember> groupMembers;
    @TestVisible private static List<ConnectApi.BatchInput> batchInputs;

    public static BookedTradesTriggerHandler getInstance() {
        return instance == null ? new BookedTradesTriggerHandler() : instance;
    }

    private BookedTradesTriggerHandler() {
        queue = [SELECT Id FROM Group WHERE Type = 'Queue' AND Name = :Settings.QUEUE_TRADE_REVIEWERS];
        groupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN :queue];
        batchInputs = new List<ConnectApi.BatchInput>();
    }

    //SET THE TRADE ID beforeInsert
    public void setTradesId(List<Booked_Trade__c> newList) {
        for (Booked_Trade__c bt : newList) {
            bt.Trade_Id__c = Settings.BOOKED_TRADE_ID_PREFIX + Utility.generateRandomString(7);
        }
    }

    //POST TO CHATTER AFTER THE TRADE IS CREATED
    public void postChatter(List<Booked_Trade__c> newList) {
        for (Booked_Trade__c bt : newList) {
            String content = 'A new trade has been created with the following data:';
            content += '\r\nSell Currency: ' + bt.Sell_Currency__c;
            content += '\r\nSell Amount: ' + bt.Sell_Amount__c;
            content += '\r\nBuy Currency: ' + bt.Buy_Currency__c;
            content += '\r\nBuy Amount: ' + bt.Buy_Amount__c;
            content += '\r\nRate: ' + bt.Rate_Booked__c;
            content += '\r\nBooked Date: ' + bt.CreatedDate.format('dd MMMM yyyy, HH:mm:ss');
			
            for (GroupMember member : groupMembers) {
                ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(Utility.chatterTextPost(member.UserOrGroupId, content));
                batchInputs.add(batchInput);
            }
        }

        //BYPASSING THE TEST HERE AS WE NEED TO SET SEEALLDATA = TRUE, BASED ON MY EXPERIENCE, I'M A BIT HESITANT TO DO THIS.
        if (!Test.isRunningTest()) {
            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
        }
    }
}