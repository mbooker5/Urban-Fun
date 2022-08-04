//
//  GoogleMapsViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 8/4/22.
//

#import "GoogleMapsViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface GoogleMapsViewController ()

@end

@implementation GoogleMapsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      CLLocation *activityLocation = [HelperClass getCLLocationForGeoPoint:self.activity.location];
      GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:activityLocation.coordinate.latitude
                                                              longitude:activityLocation.coordinate.longitude
                                                                   zoom:13];
      GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.frame camera:camera];
      mapView.myLocationEnabled = YES;
      [self.view addSubview:mapView];

      // Creates a marker in the center of the map.
      GMSMarker *marker = [[GMSMarker alloc] init];
      marker.position = CLLocationCoordinate2DMake(activityLocation.coordinate.latitude, activityLocation.coordinate.longitude);
      marker.title = self.activity.title;
      marker.snippet = self.activity.address;
      marker.map = mapView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
