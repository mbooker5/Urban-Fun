//
//  SearchViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "SearchViewController.h"
#import "Activity.h"
#import "User.h"
#import "TimelineCell.h"
#import "ProfileViewController.h"
#import "ActivityDetailsViewController.h"
#import "HelperClass.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, TimelineCellDelegate, ActivityDetailsDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filtersButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchControl;
@property (nonatomic, strong) User *profileToView;
@property (nonatomic, strong) const CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
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
        [HelperClass activityQuerywithText:searchText onVC:self];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        [HelperClass userQuerywithText:searchText onVC:self];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //removing white space
    searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (self.searchControl.selectedSegmentIndex == 0){
        [HelperClass activityQuerywithText:searchText onVC:self];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        [HelperClass userQuerywithText:searchText onVC:self];
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
}

@end
