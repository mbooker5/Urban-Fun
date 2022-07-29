//
//  User.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/25/22.
//

#import "PFUser.h"
#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : PFUser
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *objectId;
@property (nonatomic, strong) NSArray *activitiesHosted;
@property (nonatomic, strong) NSArray *followerList;
@property (nonatomic, strong) NSArray *followingList;


+ (void) updateFollowersforUser:(User *)user1 followedBy:(User *)user2 withCompletion: (PFBooleanResultBlock  _Nullable)completion;

@end

NS_ASSUME_NONNULL_END
