// CLASS USED TO STORE SETTINGS THAT DONT CHANGE REGULARLY AND KEEP ONE SOURCE OF STATIC VALUES

public with sharing class Settings {
    public static final String FIXER_API_ACCESS_KEY = 'access_key';
    public static final String FIXER_API_ACCESS_KEY_VALUE = 'c9ea375d5efd6a2f957b02fc374067a5';
    public static final String FIXER_API_ACCESS_TOKEN =  FIXER_API_ACCESS_KEY + '=' + FIXER_API_ACCESS_KEY_VALUE;
    public static final String APPLICATION_JSON = 'application/json';

    public static final String FIXER_API = 'callout:FixerAPI';
    public static final String FIXER_SYMBOLS_API = FIXER_API + '/symbols?' + FIXER_API_ACCESS_TOKEN;
    public static final String FIXER_LATEST_API = FIXER_API + '/latest?' + FIXER_API_ACCESS_TOKEN;

    public static final String BOOKED_TRADE_ID_PREFIX = 'TR' ;
    public static final String QUEUE_TRADE_REVIEWERS = 'Trade Reviewers';
}