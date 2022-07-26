//
//  SetLocationViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SelectLocationViewController.h"
#import "Contacts/Contacts.h"
#import"ContactsUI/ContactsUI.h"

@interface SelectLocationViewController () <CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) const CLLocationManager *manager;
@property (nonatomic, readwrite) CLLocationCoordinate2D *locationCoordinate;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
- (void) renderMapView: (CLLocation *)location;
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
    
    [[self.addressLabel layer] setCornerRadius:9.0f];
    [[self.addressLabel layer] setMasksToBounds:YES];
}

- (void) handleLongTapGesture: (UILongPressGestureRecognizer *) gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded){
        [self.mapView removeAnnotations:self.mapView.annotations];
        CGPoint touchLocation = [gestureRecognizer locationInView:self.mapView];
        CLLocationCoordinate2D locationCoordinate = [self.mapView convertPoint:touchLocation toCoordinateFromView:self.mapView];
        [self.locationVCDelegate setLocationPoint:locationCoordinate withLatitude:locationCoordinate.latitude withLongitude:locationCoordinate.longitude];
        MKPointAnnotation *longTapPin = [[MKPointAnnotation alloc] initWithCoordinate:locationCoordinate];
        longTapPin.title = [[NSString alloc] initWithFormat:@"%@", @"My Activity"];
        [self.mapView addAnnotation:longTapPin];
        CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
        [self getAddressFromLocation:location];
    }
    
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan){
        return;
    }
}

-(void)getAddressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!placemarks) {
             // handle error
         }

         if(placemarks && placemarks.count > 0)
         {
             CLPlacemark *placemark= [placemarks objectAtIndex:0];
             if ([placemark name]){
                 if ([placemark locality]){
                     NSString *address = [NSString stringWithFormat:@"%@, %@, %@", [placemark name], [placemark locality], [placemark administrativeArea]];
                     self.addressLabel.text = address;
                     [self.locationVCDelegate setAddressLabel:address];
                 }
                 else{
                     NSString *address = [placemark name];
                     self.addressLabel.text = address;
                     [self.locationVCDelegate setAddressLabel:address];
                 }
                 
             }
             if([placemark subThoroughfare] && [placemark thoroughfare])
             {
             NSString *address = [NSString stringWithFormat:@"%@ %@, %@, %@ %@", [placemark subThoroughfare],[placemark thoroughfare],[placemark locality], [placemark administrativeArea], [placemark postalCode]];
                 self.addressLabel.text = address;
                 [self.locationVCDelegate setAddressLabel:address];
             }
         }
     }];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.firstObject){
        [manager stopUpdatingLocation];
        [self renderMapView:locations.firstObject];
    }
}

// zooms mapView to show user's location and the surrounding region
- (void) renderMapView: (CLLocation *)location{
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(centerCoordinate, span);
    [self.mapView setRegion:region animated:YES];
    
 }
@end
