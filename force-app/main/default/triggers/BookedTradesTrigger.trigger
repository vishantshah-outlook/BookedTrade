//Booked_Trade__c TRIGGER
trigger BookedTradesTrigger on Booked_Trade__c (before insert, after insert) {

    //BEFORE INSERT - SET THE TRADE ID ON RECORDS.
    if (Trigger.isBefore && Trigger.isInsert) {
        BookedTradesTriggerHandler.getInstance().setTradesId((List<Booked_Trade__c>) Trigger.new);
    }

    //AFTER INSERT POST TO CHATTER
    if (Trigger.isAfter && Trigger.isInsert) {
        BookedTradesTriggerHandler.getInstance().postChatter((List<Booked_Trade__c>) Trigger.new);
    }
}