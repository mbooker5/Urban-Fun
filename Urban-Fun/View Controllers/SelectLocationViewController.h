//
//  SetLocationViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LocationViewDelegate <NSObject>
- (void)setLocationPoint:(CLLocationCoordinate2D)activityLocation withLatitude:(CLLocationDegrees)activityLatitude withLongitude:(CLLocationDegrees)activityLongitude;
- (void)setAddressLabel:(NSString *)address;
@end

@interface SelectLocationViewController : UIViewController
@property (nonatomic, weak) id <LocationViewDelegate> locationVCDelegate;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D pinLocation;
@property (nonatomic, strong) NSString *addressString;
@end

NS_ASSUME_NONNULL_END
