//
//  HelperClass.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/22/22.
//

#import "HelperClass.h"
#import <MapKit/MapKit.h>


@implementation HelperClass

+ (void)showAlertWithTitle:(NSString *)alertTitle withMessage:(NSString *)alertMessage withActionTitle:(NSString *)actionTitle withHandler:(nullable SEL)func onVC:(UIViewController *)vc {

    UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){if (func != nil){[vc performSelector:func];}}];
    [alert addAction:defaultAction];
    [vc presentViewController:alert animated:YES completion:nil];
}

+ (void) activityQuerywithText:(NSString *)searchText withFilters:(NSMutableDictionary *)filtersDictionary withCompletion:(void(^)(NSArray *activities))completion {
    PFQuery *activityQuery = [Activity query];
    [activityQuery whereKey:@"title" matchesRegex:searchText modifiers:@"i"];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery includeKey:@"host"];
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *>*activities , NSError *error) {
        if (error) {
            
        }
        
        completion(activities);
    }];
}

+ (CLLocation *)getCLLocationForGeoPoint:(PFGeoPoint *)location{
    return [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
}

+ (NSNumber *)distanceFromUserLocation:(CLLocation *)userLocation forActivity:(Activity *)activity {
    CLLocation *activityLocationCL = [self getCLLocationForGeoPoint:activity.location];
    CLLocationDistance distanceFromUser = [userLocation distanceFromLocation:activityLocationCL];
    CLLocationDistance distanceInMiles = distanceFromUser * 0.000621371;
    NSNumber *distance = [NSNumber numberWithDouble:distanceInMiles];
    return distance;
}

+ (void) userQuerywithText:(NSString *)searchText onVC:(SearchViewController *)vc {
    PFQuery *userQuery = [User query];
    [userQuery whereKey:@"username" matchesRegex:searchText modifiers:@"i"];
    [userQuery includeKey:@"host"];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray<User *>*users , NSError *error) {
        if (error) {
            
        }
        vc.usersArray = users;
        [vc.tableView reloadData];
    }];
}

@end
