//CLASS USED TO PROVIDE FEATURES THAT ARE SHARED ACROSS VARIOUS CLASSES TO REDUCE CODE DUPLICATION
public with sharing class Utility {

    //STORE ALL THE DATA FROM Lightning_Datatable__mdt CUSTOM METADATA
    static Map<String, String> lightningDatatables;

    //METHOD TO EXTRACT ALL Lightning_Datatable__mdt RECORDS AND STORE IN MAP
    private static void populateDatatable() {
        lightningDatatables = new Map<String, String>();
        for (Lightning_Datatable__mdt dt : [SELECT DeveloperName, Structure__c FROM Lightning_Datatable__mdt]) {
            lightningDatatables.put(dt.DeveloperName, dt.Structure__c);
        }
    }

    //SINGLETON METHOD TO GET THE Lightning_Datatable__mdt RECORD BASED ON datatableName PASSED
    public static Object getLightningDatatable(String datatableName) {
        if (lightningDatatables == null) {
            populateDatatable();
        }

        if (lightningDatatables.containsKey(datatableName)) {
            return (List<Object>) JSON.deserializeUntyped(lightningDatatables.get(datatableName));
        }

        return '';
    }

    //GENERATE RANDOM STRING BASED ON THE length PASSED IN
    public static String generateRandomString(Integer length){
        final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
        String randStr = '';
        while (randStr.length() < length) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr.toUpperCase();
    }

    //UTILITY METHOD TO GET DATA FROM fixer API
    public static String getFixerAPIData(String service){
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setHeader('Content-Type', Settings.APPLICATION_JSON);
        httpRequest.setHeader('Accept', Settings.APPLICATION_JSON);
        httpRequest.setMethod('GET');
        httpRequest.setEndpoint(service);
        HttpResponse httpApiResponse = new Http().send(httpRequest);
        return httpApiResponse.getBody();
    }

    //CHATTER POST HELPER
    public static ConnectApi.FeedItemInput chatterTextPost(Id userId, String postText) {
        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();

        input.subjectId = userId;

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = postText;

        body.messageSegments.add(textSegment);
        input.body = body;

        return input;
    }
}