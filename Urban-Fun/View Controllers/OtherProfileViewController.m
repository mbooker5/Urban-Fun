//
//  OtherProfileViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/26/22.
//

#import "OtherProfileViewController.h"
#import "User.h"

@interface OtherProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) IBOutlet UILabel *hostedCount;
@property (strong, nonatomic) IBOutlet UILabel *followerCount;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@end

@implementation OtherProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [User currentUser];
    [self setUpView];
}

- (void)setUpView {
    self.usernameLabel.text = self.profileToView.username;
    if ([self.profileToView.objectId isEqualToString:self.currentUser.objectId]){
        [self.followButton setTitle:@"Profile Settings" forState:UIControlStateNormal];
    }
    else{
        if ([_currentUser.followingList containsObject:self.profileToView.objectId]){
            [self.followButton setSelected:YES];
        }
        else{
            [self.followButton setSelected:NO];
        }
    }
    NSArray *activitiesHosted = self.profileToView.activitiesHosted;
    self.hostedCount.text = [NSString stringWithFormat:@"%lu", activitiesHosted.count];
    
    NSArray *followerList = self.profileToView.followerList;
    self.followerCount.text = [NSString stringWithFormat:@"%lu", followerList.count];
    
    NSArray *followingList = self.profileToView.followingList;
    self.followingCount.text = [NSString stringWithFormat:@"%lu", followingList.count];
}

- (IBAction)didTapFollowButton:(id)sender {
    if ([self.profileToView.objectId isEqualToString:self.currentUser.objectId]){
        [self performSegueWithIdentifier:@"profileSettings" sender:self];
    }
    else{
        [User updateFollowersforUser:self.profileToView followedBy:self.currentUser withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            [self setUpView];
        }];
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
