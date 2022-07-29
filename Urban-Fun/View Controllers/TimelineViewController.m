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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, ActivityDetailsDelegate, TimelineCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfActivities;
@property (nonatomic, strong) const CLLocationManager *manager;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (nonatomic, strong) User *profileToView;
@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading thnre view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorColor = [UIColor darkGrayColor];
    [self getActivities];
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self.tableView reloadData];
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyHundredMeters; //battery
    [self.manager requestWhenInUseAuthorization];
    if (CLLocationManager.locationServicesEnabled){
        [self.manager startUpdatingLocation];
    }
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getActivities];
    [refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

-(void)getActivities{
    PFQuery *activityQuery = [Activity query];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery includeKey:@"host"];
    activityQuery.limit = 20;

  
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activities, NSError * _Nullable error) {
        if (activities) {
            self.arrayOfActivities = activities;
        }
        else if (error != nil){
            [HelperClass showAlertWithTitle:@"Network Error" withMessage:@"Please connect to the internet and press OK." withActionTitle:@"OK" withHandler:@selector(getActivities) onVC:self];
        }
        [self.tableView reloadData];
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




- (IBAction)didTapLogout:(id)sender {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
    sceneDelegate.window.rootViewController = loginViewController;
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {

    }];
    
}



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"activitydetails"]){
        NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
        Activity *dataToPass = self.arrayOfActivities[myIndexPath.row];
        ActivityDetailsViewController *vc = [segue destinationViewController];
        vc.activity = dataToPass;
        vc.activitydetailsDelegate = self;
    }
    if ([[segue identifier] isEqualToString:@"otherProfileView"]){
        OtherProfileViewController *vc = [segue destinationViewController];
        vc.profileToView = self.profileToView;
    }
}


- (void)didTapUsername:(nonnull User *)user {
    self.profileToView = user;
    [self performSegueWithIdentifier:@"otherProfileView" sender:NULL];
}


@end
