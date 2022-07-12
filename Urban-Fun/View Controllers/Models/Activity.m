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

+ (void) postUserActivity:( UIImage * _Nullable )image withTitle: ( NSString * _Nullable)title withDescription:( NSString * _Nullable )description withCategories:( NSMutableArray * _Nullable)categories withCompletion: (PFBooleanResultBlock  _Nullable)completion {
    
    Activity *newActivity = [Activity new];
    newActivity.image = [self getPFFileFromImage:image];
    newActivity.host = [PFUser currentUser];
    newActivity.title = title;
    newActivity.description = description;
    newActivity.categories = categories;
    newActivity.favoriteCount = @(0);
    newActivity.commentCount = @(0);
    newActivity.attendanceList = [NSMutableArray new];
    newActivity.queueList = [NSMutableArray new];
    
    [newActivity saveInBackgroundWithBlock: completion];
    
}

+ (PFFileObject *)getPFFileFromImage: (UIImage * _Nullable)image {
 
    if (!image) {
        return nil;
    }
    
    CGSize size = CGSizeMake(414.0, 345.0);
    image = [self resizeImage:image withSize:size];
    NSData *imageData = UIImagePNGRepresentation(image);
    // get image data and check if that is not nil
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
