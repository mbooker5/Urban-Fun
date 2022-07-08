//
//  Activity.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "Activity.h"

@implementation Activity
@dynamic activityID;
@dynamic userID;
@dynamic host;
@dynamic title;
@dynamic description;
@dynamic categories;
@dynamic image;
@dynamic favoriteCount;
@dynamic commentCount;
@dynamic attendanceList;
@dynamic queueList;

+ (nonnull NSString *)parseClassName {
    return @"Activity";
}

+ (void) postUserActivity:( UIImage * _Nullable )image withTitle: ( NSString * _Nullable)title withDescription:( NSString * _Nullable )description withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Activity *newActivity = [Activity new];
//    newPost.image = [self getPFFileFromImage:image];
    newActivity.host = [PFUser currentUser];
    newActivity.title = title;
    newActivity.description = description;
    newActivity.categories = [NSMutableArray new];
    newActivity.favoriteCount = @(0);
    newActivity.commentCount = @(0);
    newActivity.attendanceList = [NSMutableArray new];
    newActivity.queueList = [NSMutableArray new];
    
    [newActivity saveInBackgroundWithBlock: completion];
    
}




















@end

