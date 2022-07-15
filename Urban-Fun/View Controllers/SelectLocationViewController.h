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

- (void)setLocationPoint:(CLLocationCoordinate2D *)activityLocation;

@end

@interface SelectLocationViewController : UIViewController
@property (nonatomic, weak) id <LocationViewDelegate> delegate2;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

NS_ASSUME_NONNULL_END
