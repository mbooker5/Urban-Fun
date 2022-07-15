//
//  Activity.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "PFObject.h"
#import "Parse/Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface Activity : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *activityID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) PFUser *host;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *activityDescription;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic) NSNumber *minimumAge;
@property (nonatomic) NSNumber *maximumAge;
@property (nonatomic, strong) PFFileObject *image;
@property (nonatomic, strong) NSNumber *favoriteCount;
@property (nonatomic, strong) NSNumber *commentCount;
@property (nonatomic, strong) NSMutableArray *attendanceList;
@property (nonatomic, strong) NSMutableArray *queueList;


+ (void) postUserActivity:( UIImage * _Nullable )image withTitle: ( NSString * _Nullable)title withDescription:( NSString * _Nullable)activityDescription withCategories:( NSMutableArray * _Nullable)categories withMinAge:( NSNumber * _Nullable ) minimumAge withMaxAge:( NSNumber * _Nullable ) maximumAge withCompletion: (PFBooleanResultBlock  _Nullable)completion;

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image;

@end

NS_ASSUME_NONNULL_END
