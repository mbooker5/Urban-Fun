# Urban-Fun
Urban Fun Project Plan
Overview
Description
Urban Fun is a social networking app that allows users to create, find, and join local activities in an efficient and organized way. This app promotes a community environment because it allows its users to connect and have fun with random people.

App Evaluation
Category: Social media/Lifestyle
Mobile: This app will only be on mobile platforms because computers are not as practical when on the move as this app urges users to travel outside of their homes.
Story: Analyzes users age, location, and favorite hobbies/activities and pushes activities hosted or joined by similar users to the activity timeline
Market: Any individual could choose to use this app, however, its optimal use would be by users in urban/metropolitan areas. 
Habit: This app could be used as often as the user wanted depending on how socially active they want to be.
Scope: We would start with recommending activities based on age, location, and favorite hobbies/activities...
Product Spec
User Stories (Required and Optional)
Required
User can login/sign up (Week 1)
User can set DOB/location/favorite categories (Week 2)
Persistent User (Week 1)
User can create activities with desired settings (age range, time frame, # of users (optional), and location) (Week 1)
 Keep the activities to show them as passed activities
User can join activities (Week 2)
User can search for activities using filters (age range, location, time frame, category) (Week 3)
“Home Feed” with activities (Week 2)
Profile pages for each user (profile pic, bio/intro, username) (Week 3)
	
Optional
Ability to add friends
“Home Feed” can also recommend activities that friends are currently hosting or participating in
Ability to join queue for activities that have a limit for the amount of people who can join
“Home Feed” with automatically recommended activities 
Profile page includes activities hosted by user, upcoming activities, and passed activities
…..

Screen Archetypes
Wireframes
Barebone outline of view controllers that will definitely be implemented in app…I might add more
https://pxl.cl/27zlq

Schema
Models
Post
Properties:
objectId
Author (pointer to User Model)
Image
Caption
usersInterested
usersJoined
createdAt
updatedAt

Activities
Properties:
objectID
Author (pointer to User Model)
activityTitle
activityAge (age that the activity is catered to)
activityTime (time that the activity will start)
activityDescription (description)
joinedUsers (list)
queuedUsers (list)

User
Properties:
userName
userUsername
userProfilePicture
userBio
userFavoriteActitvies (will be set categories like indoor sports, outdoor sports, cookouts, clubs, bars, concerts, etc…)
userDOB
userAge (will be derived from DOB)


Passed Activities

Feature Milestones
Week 1

User can login/sign up (Week 1)
Persistent User (Week 1)
User can create activities with desired settings (age range, time frame, # of users (optional), and location) (Week 1)


Week 2
User can join activities (Week 2)
“Home Feed” with activities (Week 2)
User can set DOB/location/favorite categories (Week 2)
Week 3
User can search for activities using filters (age range, location, time frame, category) (Week 3)
Profile pages for each user (profile pic, bio/intro, username) (Week 3)
