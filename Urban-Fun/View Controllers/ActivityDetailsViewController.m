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
#import "SceneDelegate.h"
#import "UIImageView+AFNetworking.h"
#import "GoogleMapsViewController.h"

@interface ActivityDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsHostLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsLocationLabel;
@property (strong, nonatomic) IBOutlet UIButton *detailsFavoriteButton;
@property (strong, nonatomic) IBOutlet UIButton *detailsJoinButton;
@property (strong, nonatomic) IBOutlet UILabel *detailsAttendanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailsDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailsImage;
@property (nonatomic, strong) User *profileToView;
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
    if (![self.activity.host.objectId isEqualToString:currentUser.objectId]){
        [Activity updateAttendanceListWithUserId:currentUser.objectId withActivity:self.activity withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [self setUpView];
            [self.activitydetailsDelegate syncButtons];
    }];
        }
    
}

- (void)setUpView {
    self.detailsTitle.text = self.activity.title;
    self.detailsHostLabel.text = [NSString stringWithFormat:@"%@%@", @"Host - ", self.activity.host[@"username"]];
    self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu", @"Attendance - ", self.activity.attendanceList.count];
    self.detailsDescriptionLabel.text = [NSString stringWithFormat:@"%@%@", @"Description - ", self.activity.activityDescription];
    [self.detailsJoinButton setTitle:@"Join" forState:UIControlStateNormal];
    [self.detailsImage setImageWithURL:[NSURL URLWithString:self.activity.image.url]];
    User *currentUser = [User currentUser];
    
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
    }
    else if ([_activity.attendanceList containsObject:currentUser.objectId]){
        [self.detailsJoinButton setSelected:YES];
        NSUInteger placeInLine = [_activity.attendanceList indexOfObject:currentUser.objectId];
        // conditional below addresses edge case: only users who are able to attend should be able to see address
        if (placeInLine <= [self.activity.maxUsers intValue] - 1){
            self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", self.activity.address];
        }
    }
    else {
        [self.detailsJoinButton setSelected:NO];
        self.detailsLocationLabel.text = [NSString stringWithFormat:@"%@%@", @"Location - ", @"Join to see address"];
    }

    if ([self.activity.maxUsers intValue] > 0){
        if ([_activity.attendanceList containsObject:currentUser.objectId]){
        self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu%@%@%@", @"Attendance - ", self.activity.attendanceList.count, @"/", self.activity.maxUsers, @" *Joined*"];
        }
        else{
            self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%lu%@%@", @"Attendance - ", self.activity.attendanceList.count, @"/", self.activity.maxUsers];
        }
        if (self.activity.attendanceList.count >= [self.activity.maxUsers intValue]){
            self.detailsAttendanceLabel.text = [NSString stringWithFormat:@"%@%@%@%@%@", @"Attendance - ", self.activity.maxUsers, @"/", self.activity.maxUsers, @" (Full)"];
            NSUInteger placeInLine = [_activity.attendanceList indexOfObject:currentUser.objectId];
            if ([_activity.attendanceList containsObject:currentUser.objectId]){
                if (placeInLine <= [self.activity.maxUsers intValue] - 1){
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
- (IBAction)didTapHost:(id)sender {
    
    [self performSegueWithIdentifier:@"profileFromDetails" sender:sender];
}

- (IBAction)didTapDistance:(id)sender{
    if (([self.activity.host.objectId isEqualToString:[User currentUser].objectId]) || (([self.activity.attendanceList containsObject:[User currentUser].objectId]) && ([self.activity.attendanceList indexOfObject:[User currentUser].objectId] <= [self.activity.maxUsers intValue] - 1))){
        
        [self performSegueWithIdentifier:@"googleMaps" sender:self.activity];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 if ([[segue identifier] isEqualToString:@"profileFromDetails"]){
     ProfileViewController *vc = [segue destinationViewController];
     if (![self.activity.host.objectId isEqualToString:[User currentUser].objectId]){
         vc.profileToView = self.activity.host;
     }
 }
    if ([[segue identifier] isEqualToString:@"activitydetails"]){
        AttendanceViewController *vc = [segue destinationViewController];
        vc.activity = self.activity;
    }
    if ([[segue identifier] isEqualToString:@"attendanceList"]){
        AttendanceViewController *vc = [segue destinationViewController];
        vc.activity = self.activity;
    }
    if ([[segue identifier] isEqualToString:googleMapsVCSegue]){
        GoogleMapsViewController *vc = [segue destinationViewController];
        vc.activity = (Activity *)sender;
    }
}



@end
