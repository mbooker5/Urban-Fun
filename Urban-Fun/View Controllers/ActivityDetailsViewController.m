//
//  ActivityDetailsViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/18/22.
//

#import "ActivityDetailsViewController.h"
#import "PFUser.h"

@interface ActivityDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsHostLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLocationLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailsFavoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsJoinButton;
@property (strong, nonatomic) IBOutlet UILabel *detailsAttendanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsDescriptionLabel;
@property (strong,nonatomic) PFUser *currentUser;

- (void) setUpView;
@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (IBAction)didTapJoin:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        }
    else{
        [Activity updateAttendanceListWithUserId:currentUser.objectId withActivity:self.activity withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if ([self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.detailsJoinButton setSelected:YES];
            }
            else if (![self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.detailsJoinButton setSelected:NO];
            }
            [self setUpView];
            
        }];
        
    }
    
}

- (void)setUpView {
    self.detailsTitle.text = self.activity.title;
    self.detailsHostLabel.text = [NSString stringWithFormat:@"%@%@", @"Host - ", self.activity.host[@"username"]];
    self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu", @"Attendance - ", (unsigned long)self.activity.attendanceList.count];
    PFUser *currentUser = [PFUser currentUser];
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
    }
    else if ([_activity.attendanceList containsObject:currentUser.objectId]){
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
    }
    else{
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", @"Join to see address"];
    }
    self.detailsDescriptionLabel.text = [NSString stringWithFormat:@"%@%@", @"Description - ", self.activity.activityDescription];
    if ([_activity.attendanceList containsObject:currentUser.objectId]){
        [self.detailsJoinButton setSelected:YES];
    }
    if ([self.activity.maxUsers intValue] > 0){
        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu%@%@", @"Attendance - ", (unsigned long)self.activity.attendanceList.count, @"/", self.activity.maxUsers];
        if (self.activity.attendanceList.count >= [self.activity.maxUsers intValue]){
            [self.detailsJoinButton setTitle:@"Join Queue" forState:UIControlStateNormal];
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
