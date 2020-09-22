# Booked Trade App

Execute the code below to view the Lightning App Booked Trade

Steps

#1. Checkout from GIT
#2. Create scratch org
#3. Deploy to scratch org
#4. Execute Script to create members on Trade reviewers queue
#5. Run tests
#6. open Booked Trades app on browser

call git clone https://github.com/vishantshah-outlook/BookedTrade.git

call sfdx force:org:create -s -f BookedTrade/config/project-scratch-def.json -a booktrade-org

cd BookedTrade

call sfdx force:source:push -f

call sfdx force:apex:execute -f scripts/apex/QueueMemberCreation.apex

call sfdx force:apex:test:run --tests "BookedTradesTest,BookedTradesTriggerHandlerTest"

call sfdx force:org:open -p lightning/n/Booked_Trades

Once the Browser has loaded, You should see the Booked Trades app. On the app you can view existing trades or create a new one by clicking the New button. Currently the feature is limited to EUR currency due to limitations within the API

Once a Trade is created the data grid will refresh and show the trade added

A chatter feed will also be created for all users in the Trade Reviewers queue
