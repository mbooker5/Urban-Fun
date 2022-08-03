//
//  HelperClass.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/22/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Activity.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const kDistance = @"distance";
static NSString *const kDistanceSliderValue = @"distanceSliderValue";
static NSString *const kCategories = @"categories";
static NSString *const kCategoriesCount = @"categoriesCount";
static NSString *const kMinimumAge = @"minimumAge";
static NSString *const kMaximumAge = @"maximumAge";
static NSString *const kAvailability = @"availability";

@interface HelperClass : NSObject
+ (void)showAlertWithTitle:(NSString *)alertTitle withMessage:(NSString *)alertMessage withActionTitle:(NSString *)actionTitle withHandler:(nullable SEL)func onVC:(UIViewController *)vc;

+ (void) activityQuerywithText:(NSString *)searchText useFilters:(NSMutableDictionary *)filtersDictionary withCompletion:(void(^)(NSArray *activities))completion;

+ (void) userQuerywithText:(NSString *)searchText withCompletion:(void(^)(NSArray *users))completion;

+ (NSNumber *) distanceFromUserLocation:(CLLocation *)userLocation forActivity:(Activity *)activity;

+ (CLLocation *)getCLLocationForGeoPoint:(PFGeoPoint *)location;
@end

NS_ASSUME_NONNULL_END
