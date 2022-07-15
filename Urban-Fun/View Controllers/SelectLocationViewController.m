//
//  SetLocationViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SelectLocationViewController.h"

@interface SelectLocationViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) const CLLocationManager *manager;
- (void) render: (CLLocation *)location;
@end

@implementation SelectLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.manager = [[CLLocationManager alloc] init];
    self.mapView.delegate = self;
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest; //battery
    [self.manager requestWhenInUseAuthorization];
    
    if (CLLocationManager.locationServicesEnabled){
        [self.manager startUpdatingLocation];
    }
    UILongPressGestureRecognizer *longTapGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTapGesture:)];
    [self.mapView addGestureRecognizer: longTapGesture];
    
}

- (void) handleLongTapGesture: (UILongPressGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded){
        [self.mapView removeAnnotations:self.mapView.annotations];
        CGPoint touchLocation = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D locationCoordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        
        MKPointAnnotation *longTapPin = [[MKPointAnnotation alloc] initWithCoordinate:locationCoordinate];
        longTapPin.title = [[NSString alloc] initWithFormat:@"%@%.20lf%@%.20lf", @"Latitude: ", locationCoordinate.latitude, @"Longitude: ", locationCoordinate.longitude];
        [self.mapView addAnnotation:longTapPin];
        
    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.firstObject){
        [manager stopUpdatingLocation];
        [self render:locations.firstObject];
    }
}

- (void) render: (CLLocation *)location{
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
    
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
