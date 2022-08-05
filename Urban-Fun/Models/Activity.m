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
@dynamic activityDescription;
@dynamic categories;
@dynamic minimumAge;
@dynamic maximumAge;
@dynamic image;
@dynamic favoriteCount;
@dynamic commentCount;
@dynamic attendanceList;
@dynamic queueList;
@dynamic location;
@dynamic address;
@dynamic maxUsers;

+ (nonnull NSString *)parseClassName {
    return @"Activity";
}

+ (void)postUserActivity:( UIImage * _Nullable )image withTitle: ( NSString * _Nullable)title withDescription:( NSString * _Nullable)activityDescription withCategories:( NSMutableArray * _Nullable)categories withMinAge:( NSNumber * _Nullable ) minimumAge withMaxAge:( NSNumber * _Nullable ) maximumAge withLocation:(PFGeoPoint *)location withAddress:(NSString *)address withMaxUsers:( NSNumber * _Nullable )maxUsers withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Activity *newActivity = [Activity new];
    newActivity.image = [self getPFFileFromImage:image];
    newActivity.host = [User currentUser];
    newActivity.title = title;
    newActivity.activityDescription = activityDescription;
    newActivity.categories = categories;
    newActivity.minimumAge = minimumAge;
    newActivity.maximumAge = maximumAge;
    newActivity.favoriteCount = @(0);
    newActivity.commentCount = @(0);
    newActivity.attendanceList = [NSMutableArray new];
    newActivity.queueList = [NSMutableArray new];
    newActivity.location = location;
    newActivity.address = address;
    newActivity.maxUsers = maxUsers;


    
    [newActivity saveInBackgroundWithBlock: completion];
 
}

+ (void) updateAttendanceListWithUserId:(NSString *)userID withActivity:(Activity *)activity withCompletion: (PFBooleanResultBlock  _Nullable)completion{
    if ([activity.attendanceList containsObject:userID]){
        [activity removeObject:userID forKey:@"attendanceList"];
    }
    else {
        [activity addObject:userID forKey:@"attendanceList"];
    }
    [activity saveInBackgroundWithBlock:completion];
}


/*
 1. get query of all activities
 2. get ids
 3. function
    pass in activity id and string (userID)
 4. make new array
 5. set activity.attendanceList to new array
 6. add to new array
 7. reset activity.attendanceList to new array
 8. save in background
 */

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    if (!image) {
        return nil;
    }
    
    CGSize size = CGSizeMake(414.0, 345.0);
    image = [self resizeImage:image withSize:size];
    NSData *imageData = UIImagePNGRepresentation(image);
    // gets image data and check if that is not nil
    if (!imageData) {
        return nil;
    }
    return [PFFileObject fileObjectWithName:@"image.png" data:imageData];
}

+ (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

