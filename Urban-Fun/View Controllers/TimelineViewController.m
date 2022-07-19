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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfActivities;
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
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getActivities];
    [refreshControl endRefreshing];
    [self.tableView reloadData];
    
}

-(void)getActivities{

    PFQuery *activityQuery = [Activity query];
    [activityQuery orderByDescending:@"createdAt"];
    [activityQuery includeKey:@"author"];
    activityQuery.limit = 20;

  
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activities, NSError * _Nullable error) {
        if (activities) {
            self.arrayOfActivities = activities;
        }
        else {
        }
        [self.tableView reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfActivities.count; //
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TimelineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TimelineCell" forIndexPath:indexPath];
    
    Activity *activity = self.arrayOfActivities[indexPath.row];
    cell.activity = activity;
    [cell setTimelineCell];

    
    return cell;
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
    }
}


@end
