//
//  SearchViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "SearchViewController.h"
#import "Activity.h"
#import "User.h"
#import "Category.h"
#import "TimelineCell.h"
#import "ProfileViewController.h"
#import "ActivityDetailsViewController.h"
#import "HelperClass.h"
#import "FiltersViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, TimelineCellDelegate, ActivityDetailsDelegate, FiltersVCDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filtersButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchControl;
@property (nonatomic, strong) User *profileToView;
@property (nonatomic, strong) const CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) NSMutableDictionary *filtersDictionary;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    // dismisses keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    // dismisses keyboard when user scrolls
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    // font for selected segment control
    UIFont *font = [UIFont fontWithName:@"Verdana-Bold" size:12.0f];
    UIColor *selectedColor = [UIColor lightGrayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:selectedColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    [self.searchControl setTitleTextAttributes:attributes
                                    forState:UIControlStateSelected];
    // font for normal segment control
    UIColor *color = [UIColor colorWithRed:68.0/255.0 green:85.0/255.0 blue:96.0/255.0 alpha:1.0];
    NSMutableDictionary *attributesForNormal = [NSMutableDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [attributesForNormal setObject:font forKey:NSFontAttributeName];
    [self.searchControl setTitleTextAttributes:attributesForNormal
                                    forState:UIControlStateNormal];
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //battery
    [self.manager requestWhenInUseAuthorization];
    if (CLLocationManager.locationServicesEnabled){
        [self.manager startUpdatingLocation];
    }
    self.filtersDictionary = [[NSMutableDictionary alloc] init];
    self.filtersDictionary[@"categories"] = [[NSMutableArray alloc] init];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.firstObject){
        [manager stopUpdatingLocation];
        self.currentUserLocation = locations.firstObject;
    }
}

- (IBAction)changedSearchType:(id)sender {
    NSString *searchText = self.searchBar.text;
    //removing white space
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.searchControl.selectedSegmentIndex == 0){
        [HelperClass activityQuerywithText:searchText useFilters:self.filtersDictionary withCompletion:^(NSArray * _Nonnull activities) {
            self.activitiesArray = activities;
            [self applyFilters];
            [self.tableView reloadData];
        }];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        [HelperClass userQuerywithText:searchText withCompletion:^(NSArray * _Nonnull users){
            self.usersArray = users;
            [self.tableView reloadData];
        }];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //removing white space
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.searchControl.selectedSegmentIndex == 0){
        [HelperClass activityQuerywithText:searchText useFilters:self.filtersDictionary withCompletion:^(NSArray * _Nonnull activities) {
            self.activitiesArray = activities;
            [self applyFilters];
            [self.tableView reloadData];
        }];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        [HelperClass userQuerywithText:searchText withCompletion:^(NSArray * _Nonnull users){
            self.usersArray = users;
            [self.tableView reloadData];
        }];
    }
}

- (void) applyFilters{
    if (self.filtersDictionary.allKeys.count > 0){
        NSMutableArray *temporaryDistanceArray = [[NSMutableArray alloc] init];
            if (self.filtersDictionary[kDistance] != nil){
                for (Activity *activity in self.activitiesArray){
                NSNumber *activityDistance = [HelperClass distanceFromUserLocation:self.currentUserLocation forActivity:activity];
                    if ([activityDistance floatValue] <= [self.filtersDictionary[kDistance] floatValue]){
                        [temporaryDistanceArray addObject:activity];
                    }
                }
                self.activitiesArray = temporaryDistanceArray;
            }
            if ([self.filtersDictionary[kCategoriesCount] intValue] > 0){
                NSMutableArray *temporaryCategoryArray = [[NSMutableArray alloc] init];
                for (Activity *activity in self.activitiesArray){
                    for (Category *category in self.filtersDictionary[kCategories]){
                        if ([activity.categories containsObject:category]){
                            [temporaryCategoryArray addObject:activity];
                            break;
//                            if (![temporaryCategoryArray containsObject:activity]){
//                                [temporaryCategoryArray addObject:activity];
//                            }
                        }
                    }
                    self.activitiesArray = temporaryCategoryArray;
                }
            }
            if (self.filtersDictionary[kMinimumAge] != nil){
                NSMutableArray *temporaryMinAgeArray = [[NSMutableArray alloc] init];
                int minAge = [self.filtersDictionary[kMinimumAge] intValue];
                for (Activity *activity in self.activitiesArray){
                    if (([activity.minimumAge intValue] >= minAge) && ([activity.minimumAge intValue] > 0)){
                        [temporaryMinAgeArray addObject:activity];
                    }
                }
                self.activitiesArray = temporaryMinAgeArray;
            }
            if (self.filtersDictionary[kMaximumAge] != nil){
                NSMutableArray *temporaryMaxAgeArray = [[NSMutableArray alloc] init];
                int maxAge = [self.filtersDictionary[kMaximumAge] intValue];
                for (Activity *activity in self.activitiesArray){
                    if (([activity.maximumAge intValue] <= maxAge) && ([activity.maximumAge intValue] > 0)){
                        [temporaryMaxAgeArray addObject:activity];
                    }
                }
                self.activitiesArray = temporaryMaxAgeArray;
            }
            if (self.filtersDictionary[kAvailability] != nil){
                NSMutableArray *temporaryAvailabilityArray = [[NSMutableArray alloc] init];
                int availability = [self.filtersDictionary[kAvailability] intValue];
                for (Activity *activity in self.activitiesArray){
                    if ([activity.maxUsers intValue] > 0){
                        int spaceLeft = [activity.maxUsers intValue] - [[NSNumber numberWithUnsignedLong:activity.attendanceList.count] intValue];
                        if (spaceLeft >= availability){
                            [temporaryAvailabilityArray addObject:activity];
                        }
                    }
                    else{
                        [temporaryAvailabilityArray addObject:activity];
                    }
                }
                self.activitiesArray = temporaryAvailabilityArray;
            }
        }
    }


// delegate method to pass tapped user from cell
- (void)didTapUsername:(nonnull User *)user {
    self.profileToView = user;
}
// action method
- (IBAction)usernameTapped:(id)sender {
    [self performSegueWithIdentifier:@"profileFromSearch" sender:sender];
}

- (IBAction)filtersTapped:(id)sender {
    [self performSegueWithIdentifier:@"filters" sender:sender];
}

- (void)syncButtons {
    [self.tableView reloadData];
}

- (void)updateFiltersDictionary:(NSMutableDictionary *)filtersDictionary{
    NSString *searchText = self.searchBar.text;
    self.filtersDictionary = filtersDictionary;
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.searchControl.selectedSegmentIndex == 0){
        [HelperClass activityQuerywithText:searchText useFilters:self.filtersDictionary withCompletion:^(NSArray * _Nonnull activities) {
            self.activitiesArray = activities;
            [self applyFilters];
            [self.tableView reloadData];
        }];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        [HelperClass userQuerywithText:searchText withCompletion:^(NSArray * _Nonnull users){
            self.usersArray = users;
            [self.tableView reloadData];
        }];
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.searchControl.selectedSegmentIndex == 0){
    TimelineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Activities" forIndexPath:indexPath];
        Activity *activity = self.activitiesArray[indexPath.row];
        cell.timelineCellDelegate = self;
        cell.activity = activity;
        cell.currentUserLocation = self.currentUserLocation;
        [cell setTimelineCell];
        return cell;
    }
    if (self.searchControl.selectedSegmentIndex == 1){
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Users" forIndexPath:indexPath];
        
        cell.textLabel.text = self.usersArray[indexPath.row].username;
        
        return cell;
    }
    return nil;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchControl.selectedSegmentIndex == 0 && self.searchBar.text.length > 0){
        return self.activitiesArray.count;
    }
    if (self.searchControl.selectedSegmentIndex == 1 && self.searchBar.text.length > 0){
        return self.usersArray.count;
    }
    return 0;
}

//#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"activitydetails"]){
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Activity *dataToPass = self.activitiesArray[myIndexPath.row];
        ActivityDetailsViewController *vc = [segue destinationViewController];
        vc.activity = dataToPass;
        vc.activitydetailsDelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"profileFromSearch"]){
        ProfileViewController *vc = [segue destinationViewController];
        if (![self.profileToView.objectId isEqualToString:[User currentUser].objectId]){
            vc.profileToView = self.profileToView;
        }
    }
    if ([[segue identifier] isEqualToString:@"filters"]){
        FiltersViewController *vc = [segue destinationViewController];
        vc.filtersDictionary = self.filtersDictionary;
        vc.filtersVCDelegate = self;
    }
}

@end
