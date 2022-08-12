//
//  AttendanceViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/26/22.
//

#import "AttendanceViewController.h"
#import "TimelineViewController.h"
#import "UserCell.h"
#import "ProfileViewController.h"

@interface AttendanceViewController ()  <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *userIdList;
@property (strong, nonatomic) NSMutableArray *usersArray;

@end

@implementation AttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    // Do any additional setup after loading the view.
    [self getUsersFromAttendanceList];
    [self.tableView reloadData];
    
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UserCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Users" forIndexPath:indexPath];
    if (self.usersArray.count > indexPath.row){
        User *user = self.usersArray[indexPath.row];
        cell.user = user;
        [cell setUserCell];
    }
    return cell;
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.activity.maxUsers intValue] > 0)
    {
        if (self.activity.attendanceList.count <= [self.activity.maxUsers intValue]){
            return self.activity.attendanceList.count;
        }
        else{
            return ([self.activity.maxUsers intValue]);
        }
    }
    else{
        return self.activity.attendanceList.count;
    }
}


- (void) getUsersFromAttendanceList{
    self.usersArray = [NSMutableArray new];
    for (NSString *userID in self.activity.attendanceList){
        PFQuery *userQuery = [User query];
        [userQuery whereKey:@"objectId" matchesRegex:userID modifiers:@"i"];
        [userQuery includeKey:@"host"];
        [userQuery findObjectsInBackgroundWithBlock:^(NSArray<User *>*users , NSError *error) {
            if (error) {
                
            }
            else if (users){
            [self.usersArray addObjectsFromArray:users];
            [self.tableView reloadData];
            }
        }];
    }
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 if ([[segue identifier] isEqualToString:@"profileFromUserCell"]){
     ProfileViewController *vc = [segue destinationViewController];
     NSIndexPath *myIndexPath = [self.tableView indexPathForCell:sender];
     User *profileToView = self.usersArray[myIndexPath.row];
     if (![profileToView.objectId isEqualToString:[User currentUser].objectId]){
         vc.profileToView = profileToView;
     }
  }
}




@end
