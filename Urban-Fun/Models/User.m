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


+ (void) updateFollowersforUser:(PFUser *)user1 withUserID:(NSString *)user1ID followedBy:(PFUser *)user2 withUserID:(NSString *)user2ID withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    
    if ([user1[@"followerList"] containsObject:user2ID]){
        [user1 removeObject:user2ID forKey:@"followerList"];
        [user2 removeObject:user1ID forKey:@"followingList"];
    }
    else {
        [user1 addObject:user2ID forKey:@"followerList"];
        [user2 addObject:user1ID forKey:@"followingList"];
    }
    [user1 saveInBackground];
    [user2 saveInBackground];
}


@end
