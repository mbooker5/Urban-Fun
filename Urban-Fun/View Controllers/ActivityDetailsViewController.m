//
//  ActivityDetailsViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/18/22.
//

#import "ActivityDetailsViewController.h"
#import "PFUser.h"
#import "HelperClass.h"
#import "ProfileViewController.h"
#import "OtherProfileViewController.h"
#import "AttendanceViewController.h"

@interface ActivityDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsHostLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLocationLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailsFavoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsJoinButton;
@property (strong, nonatomic) IBOutlet UILabel *detailsAttendanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsDescriptionLabel;
@property (strong,nonatomic) User *currentUser;

- (void) setUpView;
@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

- (IBAction)didTapJoin:(id)sender {
    User *currentUser = [User currentUser];
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        }
    else{
        [Activity updateAttendanceListWithUserId:currentUser.objectId withActivity:self.activity withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [self setUpView];
        }];
        
    }
    [self.activitydetailsDelegate syncButtons];
}

- (void)setUpView {
    self.detailsTitle.text = self.activity.title;
    self.detailsHostLabel.text = [NSString stringWithFormat:@"%@%@", @"Host - ", self.activity.host[@"username"]];
    self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu", @"Attendance - ", (unsigned long)self.activity.attendanceList.count];
    self.detailsDescriptionLabel.text = [NSString stringWithFormat:@"%@%@", @"Description - ", self.activity.activityDescription];
    [self.detailsJoinButton setTitle:@"Join" forState:UIControlStateNormal];
    User *currentUser = [User currentUser];
    
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
    }
    if ([_activity.attendanceList containsObject:currentUser.objectId]){
        [self.detailsJoinButton setSelected:YES];
        NSUInteger placeInLine = [_activity.attendanceList indexOfObject:currentUser.objectId];
        if (placeInLine <= [self.activity.maxUsers intValue] - 1){
            self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
        }
    }
    else {
        [self.detailsJoinButton setSelected:NO];
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", @"Join to see address"];
    }

    if ([self.activity.maxUsers intValue] > 0){
        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu%@%@", @"Attendance - ", (unsigned long)self.activity.attendanceList.count, @"/", self.activity.maxUsers];
        if (self.activity.attendanceList.count >= [self.activity.maxUsers intValue]){
            self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)"];
            NSUInteger placeInLine = [_activity.attendanceList indexOfObject:currentUser.objectId];
            if ([_activity.attendanceList containsObject:currentUser.objectId]){
                if (placeInLine <= [self.activity.maxUsers intValue] - 1){
                    self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
                    self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu%@%@%@%@", @"Attendance - ", (unsigned long)self.activity.attendanceList.count, @"/", self.activity.maxUsers, @" (Full)", @" *Joined*"];
                }
                else {
                    if (((placeInLine + 1) - [self.activity.maxUsers intValue]) - 1 % 10 == 0)
                    {
                        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)", @" *1st In Queue*"];
                    }
                    else if (((placeInLine + 1) - [self.activity.maxUsers intValue]) - 2 % 10 == 0){
                        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)", @" *2nd In Queue*"];
                    }
                    else if (((placeInLine + 1) - [self.activity.maxUsers intValue]) - 3 % 10 == 0){
                        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)", @" *3rd In Queue*"];
                    }
                    else{
                        NSUInteger placeInQueue = (placeInLine + 1) - [self.activity.maxUsers intValue];
                        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@%@%lu%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)", @" *", (unsigned long)placeInQueue, @"th In Queue*"];
                    }
                }
            }
        }
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue identifier] isEqualToString:@"profileFromDetails"]){
     OtherProfileViewController *vc = [segue destinationViewController];
     vc.profileToView = self.activity.host;
 }
    if ([[segue identifier] isEqualToString:@"activitydetails"]){
        AttendanceViewController *vc = [segue destinationViewController];
        vc.activity = self.activity;
    }
}



@end
