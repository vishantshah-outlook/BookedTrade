//Get the group you want. Queues are stored as group objects with a type of Queue
Group g = [SELECT Id FROM Group WHERE Name='Trade Reviewers' AND Type = 'Queue'];

GroupMember member = new GroupMember();
member.UserOrGroupId = UserInfo.getUserId();
member.GroupId = g.Id;

insert member;