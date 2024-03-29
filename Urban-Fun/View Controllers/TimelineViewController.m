//
//  TimelineViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "TimelineViewController.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "Activity.h"
#import "TimelineCell.h"
#import "ActivityDetailsViewController.h"
#import "HelperClass.h"
#import "ProfileViewController.h"
#import "OtherProfileViewController.h"
#import "GoogleMapsViewController.h"
#import "HostViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate, ActivityDetailsDelegate, TimelineCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfActivities;
@property (nonatomic, strong) const CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) User *profileToView;
@property (nonatomic, strong) Activity *tappedActivity;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property NSInteger setsLoaded;
@property BOOL isMoreDataLoading;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading thnre view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor darkGrayColor];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    [self.tableView reloadData];
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //battery
    [self.manager requestWhenInUseAuthorization];
    if (CLLocationManager.locationServicesEnabled){
        [self.manager startUpdatingLocation];
    }
    self.isMoreDataLoading = NO;
    self.setsLoaded = 0;
    [self getActivities];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    self.setsLoaded = 0;
    [self getActivities];
    [self.tableView reloadData];
}



-(void)getActivities{
    PFQuery *activityQuery = [Activity query];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery includeKey:@"host"];
    activityQuery.limit = 20;
    activityQuery.skip = self.setsLoaded * 20;


  
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activities, NSError * _Nullable error) {
        if (activities && self.setsLoaded > 0) {
            NSMutableArray *temporaryActivitiesArray = [[NSMutableArray alloc] initWithArray:self.arrayOfActivities];
            [temporaryActivitiesArray addObjectsFromArray:activities];
                self.setsLoaded += 1;
            self.arrayOfActivities = temporaryActivitiesArray;
        }
        else if (activities && self.setsLoaded == 0){
            self.arrayOfActivities = activities;
            self.setsLoaded += 1;
        }
        else if (error != nil){
            [HelperClass showAlertWithTitle:@"Network Error" withMessage:@"Please connect to the internet and press OK." withActionTitle:@"OK" withHandler:@selector(getActivities) onVC:self];
        }
        self.isMoreDataLoading = NO;
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    }];
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.firstObject){
        [manager stopUpdatingLocation];
        self.currentUserLocation = locations.firstObject;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfActivities.count; //
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
    Activity *activity = self.arrayOfActivities[indexPath.row];
    cell.timelineCellDelegate = self;
    cell.activity = activity;
    cell.currentUserLocation = self.currentUserLocation;
    [cell setTimelineCell];
    return cell;
}

- (void)syncButtons{
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.isMoreDataLoading){
        // Calculate the position of one screen length before the bottom of the results
        int scrollViewContentHeight = self.tableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
        
        // When the user has scrolled past the threshold, start requesting
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
            self.isMoreDataLoading = YES;
            [self getActivities];
        }
    }
}



- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

    }];
    
}

// delegate method to pass tapped user from cell
- (void)didTapUsername:(nonnull User *)user {
    self.profileToView = user;
    [self performSegueWithIdentifier:@"profileFromTimeline" sender:user];
}

- (void)didTapDistance:(Activity *)activity{
    if (([activity.host.objectId isEqualToString:[User currentUser].objectId]) || (([activity.attendanceList containsObject:[User currentUser].objectId]) && ([activity.attendanceList indexOfObject:[User currentUser].objectId] <= [activity.maxUsers intValue] - 1))){
        
        [self performSegueWithIdentifier:@"googleMaps" sender:activity];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:activityDetailsSegue]){
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Activity *activity = self.arrayOfActivities[myIndexPath.row];
        ActivityDetailsViewController *vc = [segue destinationViewController];
        vc.activity = activity;
        vc.activitydetailsDelegate = self;
        vc.navigationItem.title = activity.title;
    }
    if ([[segue identifier] isEqualToString:profileFromTimelineSegue]){
        ProfileViewController *vc = [segue destinationViewController];
        User *profileToView = sender;
        if (![profileToView.objectId isEqualToString:[User currentUser].objectId]){
            vc.profileToView = profileToView;
        }
    }
    if ([[segue identifier] isEqualToString:googleMapsVCSegue]){
        GoogleMapsViewController *vc = [segue destinationViewController];
        vc.activity = (Activity *)sender;
    }

}







@end
