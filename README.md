# Booked Trade App

Execute the code below to view the Lightning App Booked Trade

call git clone https://github.com/vishantshah-outlook/BookedTrade.git

call sfdx force:org:create -s -f BookedTrade/config/project-scratch-def.json -a booktrade-org

cd BookTrade

call sfdx force:source:push -f

call sfdx force:apex:execute -f scripts/apex/QueueMemberCreation.apex

call sfdx force:apex:test:run --tests "BookedTradesTest,BookedTradesTriggerHandlerTest"

call sfdx force:org:open

Once the Browser has loaded, in the App Launcher find Booked Trades and launch it. On the app you can view existing trades or create a new one by clicking the New button. Currently the feature is limited to EUR currency due to limitations within the API

Once a Trade is created the data grid will refresh and show the trade added

A chatter feed will also be created for all users in the Trade Reviewers queue
