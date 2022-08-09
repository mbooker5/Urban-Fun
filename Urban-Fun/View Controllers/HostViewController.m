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

@interface HostViewController () <CategoriesViewDelegate, LocationViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
@property (strong, nonatomic) IBOutlet UITextView *activityDescription;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UITextField *minAge;
@property (strong, nonatomic) IBOutlet UITextField *maxAge;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;
@property (strong, nonatomic) IBOutlet UITextField *maxUsersTextField;
@property (strong, nonatomic) PFGeoPoint *location;
@property (nonatomic) CLLocationCoordinate2D locationLatLong;
@property (strong, nonatomic) IBOutlet UIButton *selectLocation;
@property (strong, nonatomic) NSString *locationAddress;
@property (strong, nonatomic) IBOutlet UIButton *imageSelector;
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

- (IBAction)didTapImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    

   
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Image"
                                   message:@""
                                   preferredStyle:UIAlertControllerStyleActionSheet];
     
    UIAlertAction* useCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        else {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    UIAlertAction* usePhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
        handler:^(UIAlertAction * action){
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [alert addAction:useCamera];
    [alert addAction:usePhotoLibrary];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.activityImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

    - (IBAction)uploadActivity:(id)sender {
        // next six lines convert UITextFields text into an NSNumber
        int minAgeInt = [self.minAge.text intValue];
        int maxAgeInt = [self.maxAge.text intValue];
        int maxUsersInt = [self.maxUsersTextField.text intValue];
        NSNumber *minimumAge = [NSNumber numberWithInt:minAgeInt];
        NSNumber *maximumAge = [NSNumber numberWithInt:maxAgeInt];
        NSNumber *maxUsers = [NSNumber numberWithInt:maxUsersInt];
        //
        if (([self.activityTitle hasText]) && ([self.activityDescription hasText])){
            if ([self.addressLabel2.text isEqualToString:@""]){
                self.errorMessage.text = @"Please Select A Location";
            }
            else{
                
                if ((minimumAge.intValue > 0 && maximumAge.intValue > 0) && (minimumAge.intValue > maximumAge.intValue))
                {
                    self.errorMessage.text = @"Invalid Age Range";
                }
                else{
                   [Activity postUserActivity:self.activityImage.image withTitle:self.activityTitle.text withDescription:self.activityDescription.text withCategories:self.activityCategories withMinAge:minimumAge withMaxAge:maximumAge withLocation:self.location withAddress:self.locationAddress withMaxUsers:maxUsers withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                       PFQuery *activityQuery = [Activity query];
                       [activityQuery includeKey:@"host"];
                       [activityQuery orderByDescending:@"createdAt"];
                       [activityQuery whereKey:@"host" equalTo:[User currentUser]];
                       activityQuery.limit = 1;
                       [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activity, NSError * _Nullable error) {
                           if (activity){
                               Activity *recentlyPosted = activity[0];
                               [[User currentUser] addObject:recentlyPosted forKey:@"activitiesHosted"];
                               [[User currentUser] saveInBackground];
                           }
                       }];
                    }];
                }
            }
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
    self.locationLatLong = locationCoordinate;
}

-(void)setAddressLabel:(NSString *)address{
    [self.selectLocation setTitle:@"" forState:UIControlStateNormal];
    [self.addressLabel2 setText:address];
    self.locationAddress = address;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"setCategories"]){
        SelectCategoriesViewController *selectCategoriesVC = [segue destinationViewController];
        selectCategoriesVC.categoriesVCDelegate = self;
        selectCategoriesVC.selectedCategories = self.activityCategories;
    }
    if ([[segue identifier] isEqualToString:@"setLocation"]){
        SelectLocationViewController *selectLocationVC = [segue destinationViewController];
        selectLocationVC.locationVCDelegate = self;
        if (self.location){
            selectLocationVC.pinLocation = CLLocationCoordinate2DMake(self.locationLatLong.latitude, self.locationLatLong.longitude);
            selectLocationVC.addressString = self.locationAddress;
        }
    }
}

@end


