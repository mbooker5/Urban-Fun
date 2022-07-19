//
//  HostViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "HostViewController.h"
#import "SelectCategoriesViewController.h"
#import "SelectLocationViewController.h"
#import "Activity.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HostViewController () <CategoriesViewDelegate, LocationViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
@property (strong, nonatomic) IBOutlet UITextField *activityDescription;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UITextField *minAge;
@property (strong, nonatomic) IBOutlet UITextField *maxAge;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;
@property (strong, nonatomic) PFGeoPoint *location;
@property (nonatomic) CLLocationCoordinate2D locationLatLong;
@property (strong, nonatomic) IBOutlet UIButton *selectLocation;
@property (strong, nonatomic) NSString *locationAddress;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel2;

    @end

    @implementation HostViewController

    - (void)viewDidLoad {
        [super viewDidLoad];
        self.activityCategories = [[NSMutableArray alloc] init];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
        [tapGestureRecognizer setCancelsTouchesInView:NO];
        [self.view addGestureRecognizer:tapGestureRecognizer];
    }



    - (IBAction)uploadActivity:(id)sender {
        // next four lines convert UITextField text into an NSNumber
        int minAgeInt = [self.minAge.text intValue];
        int maxAgeInt = [self.maxAge.text intValue];
        NSNumber *minimumAge = [NSNumber numberWithInt:minAgeInt];
        NSNumber *maximumAge = [NSNumber numberWithInt:maxAgeInt];
        //
        if (([self.activityTitle hasText]) && ([self.activityDescription hasText])){
            [Activity postUserActivity:_activityImage.image withTitle:_activityTitle.text withDescription:_activityDescription.text withCategories:self.activityCategories withMinAge:minimumAge withMaxAge:maximumAge withLocation:self.location withAddress:self.locationAddress withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }];
        }
        else{
            self.errorMessage.text = @"Invalid Title/Description";
        }
    }

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setCategoryArray:(nonnull NSMutableArray *)selectedCategories {
    self.activityCategories = selectedCategories;
}
- (void)setLocationPoint:( CLLocationCoordinate2D)locationCoordinate withLatitude:(CLLocationDegrees)activityLatitude withLongitude:(CLLocationDegrees)activityLongitude {
    self.location = [PFGeoPoint geoPointWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    self.locationLatLong = CLLocationCoordinate2DMake(locationCoordinate.latitude, locationCoordinate.longitude);
}

-(void)setAddressLabel:(NSString *)address{
    [self.selectLocation setTitle:@"" forState:UIControlStateNormal];
    [self.addressLabel2 setText:address];
    self.locationAddress = address;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"setCategories"]){
        SelectCategoriesViewController *scVC = [segue destinationViewController];
        scVC.delegate1 = self;
        scVC.selectedCategories = [[NSMutableArray alloc] init];
        scVC.selectedCategories = self.activityCategories;
    }
    if ([[segue identifier] isEqualToString:@"setLocation"]){
        SelectLocationViewController *slVC = [segue destinationViewController];
        slVC.delegate2 = self;
        if (self.location){
            MKPointAnnotation *pin = [[MKPointAnnotation alloc] initWithCoordinate:self.locationLatLong];
            slVC.mapView = [[MKMapView alloc] init];
            [slVC.mapView addAnnotation:pin];
        }
        
    }
}






@end


