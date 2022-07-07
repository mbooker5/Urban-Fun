//
//  Activity.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Activity : PFObject
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *host;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSMutableArray *attendanceList;
@property (nonatomic, strong) NSMutableArray *queueList;
@end

NS_ASSUME_NONNULL_END
