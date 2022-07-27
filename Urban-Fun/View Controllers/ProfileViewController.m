//
//  ProfileViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "ProfileViewController.h"
#import "User.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) IBOutlet UILabel *hostedCount;
@property (strong, nonatomic) IBOutlet UILabel *followerCount;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currentUser = [PFUser currentUser];
    if (self.profileToView == nil){
        self.profileToView = [PFUser currentUser];
    }
    [self setUpView];
}

- (void)setUpView {
    self.usernameLabel.text = self.profileToView.username;
    if (self.profileToView == self.currentUser){
        [self.followButton setTitle:@"Profile Settings" forState:UIControlStateNormal];
    }
    else{
        if ([self.profileToView[@"followerList"] containsObject:self.currentUser.objectId]){
            [self.followButton setSelected:YES];
        }
        else{
            [self.followButton setSelected:NO];
        }
    }
    NSArray *activitiesHosted = self.profileToView[@"activitiesHosted"];
    self.hostedCount.text = [NSString stringWithFormat:@"%lu", activitiesHosted.count];
    
    NSArray *followerList = self.profileToView[@"followerList"];
    self.followerCount.text = [NSString stringWithFormat:@"%lu", followerList.count];
    
    NSArray *followingList = self.profileToView[@"followingList"];
    self.followingCount.text = [NSString stringWithFormat:@"%lu", followingList.count];
}

- (IBAction)didTapFollowButton:(id)sender {
    if (self.profileToView == self.currentUser){
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
