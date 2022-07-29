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

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CLLocationManagerDelegate, TimelineCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filtersButton;
@property (strong, nonatomic) IBOutlet UISegmentedControl *searchControl;
@property (nonatomic, strong) NSMutableArray<User *> *usersArray;
@property (nonatomic, strong) NSMutableArray<Activity *> *activitiesArray;
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
    // Do any additional setup after loading the view.
    UIFont *font = [UIFont fontWithName:@"Verdana-Bold" size:12.0f];
    UIColor *color = [UIColor lightGrayColor];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    
    [self.searchControl setTitleTextAttributes:attributes
                                    forState:UIControlStateSelected];
    UIColor *color2 = [UIColor colorWithRed:68.0/255.0 green:85.0/255.0 blue:96.0/255.0 alpha:1.0];
    NSMutableDictionary *attributesForNormal = [NSMutableDictionary dictionaryWithObject:color2 forKey:NSForegroundColorAttributeName];
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
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.searchControl.selectedSegmentIndex == 0){
        //removing white space
        searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PFQuery *activityQuery = [Activity query];
        [activityQuery whereKey:@"title" matchesRegex:searchText modifiers:@"i"];
        [activityQuery orderByDescending:@"createdAt"];
        [activityQuery includeKey:@"host"];
        self.activitiesArray = [[NSMutableArray alloc] init];
        [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *>*activities , NSError *error) {
            if (error) {
                
            }
            for (Activity *activity in activities) {
                if (![self.activitiesArray containsObject:activity]){
                    [self.activitiesArray addObject:activity];
                }
            }
            [self.tableView reloadData];

        }];
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        //removing white space
        searchText = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        PFQuery *userQuery = [User query];
        [userQuery whereKey:@"username" matchesRegex:searchText modifiers:@"i"];
        [userQuery includeKey:@"host"];
        self.usersArray = [[NSMutableArray alloc] init];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray<User *>*users , NSError *error) {
            if (error) {
                
            }
            for (User *user in users) {
                if (![self.usersArray containsObject:user]){
                    [self.usersArray addObject:user];
                }
            }
            [self.tableView reloadData];

        }];
    }
}

- (void)didTapUsername:(nonnull User *)user {
    self.profileToView = user;
    [self performSegueWithIdentifier:@"otherProfileView" sender:NULL];
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
    if (self.searchControl.selectedSegmentIndex == 0){
        return self.activitiesArray.count;
    }
    if (self.searchControl.selectedSegmentIndex == 1){
        return self.usersArray.count;
    }
    return 0;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (void)encodeWithCoder:(nonnull NSCoder *)coder {
//    <#code#>
//}
//
//- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
//    <#code#>
//}
//
//- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
//    <#code#>
//}
//
//- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
//    <#code#>
//}
//
//- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
//    <#code#>
//}
//
//- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
//    <#code#>
//}
//
//- (void)setNeedsFocusUpdate {
//    <#code#>
//}
//
//- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
//    <#code#>
//}
//
//- (void)updateFocusIfNeeded {
//    <#code#>
//}



@end
