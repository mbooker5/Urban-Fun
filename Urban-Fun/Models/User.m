//
//  User.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/25/22.
//

#import "User.h"

@implementation User
@dynamic username;
@dynamic objectId;
@dynamic activitiesHosted;
@dynamic followerList;
@dynamic followingList;




+ (void) updateFollowersforUser:(User *)user1 followedBy:(User *)user2 withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    if ([user2.followingList containsObject:user1.objectId]){
        [user1 removeObject:user2.objectId forKey:@"followerList"];
        [user2 removeObject:user1.objectId forKey:@"followingList"];
    }
    else {
        [user1 addObject:user2.objectId forKey:@"followerList"];
        [user2 addObject:user1.objectId forKey:@"followingList"];
    }
    [user1 saveInBackgroundWithBlock:completion];
    [user2 saveInBackgroundWithBlock:completion];
}


@end
