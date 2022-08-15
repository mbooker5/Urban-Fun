//
//  ProfileViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "ProfileViewController.h"
#import "ActivityCollectionCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) User *currentUser;
@property (strong, nonatomic) IBOutlet UILabel *hostedCount;
@property (strong, nonatomic) IBOutlet UILabel *followerCount;
@property (strong, nonatomic) IBOutlet UILabel *followingCount;
@property (strong, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonnull) NSArray *activitiesByUser;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) IBOutlet UIButton *profilePictureButton;
@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView insertSubview:self.refreshControl atIndex:0];
    self.currentUser = [User currentUser];
    if (self.profileToView == nil){
        self.profileToView = [User currentUser];
    }
    [self setUpView];
    [self getUserActivities];
    [self.collectionView reloadData];
    
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getUserActivities];
    
}

- (void)setUpView {
    self.usernameLabel.text = self.profileToView.username;
    if (self.profileToView == self.currentUser){
        [self.followButton setTitle:@"Profile Settings" forState:UIControlStateNormal];
    }
    else{
        if ([self.profileToView.followerList containsObject:self.currentUser.objectId]){
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
    
    if (self.profileToView.profilePicture.url){
        [self.profilePicture setImageWithURL:[NSURL URLWithString:self.profileToView.profilePicture.url]];
        
    }
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2.0;;
    self.profilePictureButton.layer.cornerRadius = self.profilePicture.frame.size.height/2.0;
    self.profilePicture.clipsToBounds = YES;
    self.profilePictureButton.clipsToBounds = YES;
    
}

- (void) findActivitiesByUser{
    PFQuery *activityQuery = [Activity query];
    [activityQuery includeKey:@"host"];

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



- (IBAction)didTapProfilePicture:(id)sender {
    if (self.profileToView == [User currentUser]){
        UIImagePickerController *imagePickerVC = [UIImagePickerController new];
        imagePickerVC.delegate = self;
        imagePickerVC.allowsEditing = YES;
        
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Upload Profile Picture"
                                       message:@"Please Select Image Source"
                                       preferredStyle:UIAlertControllerStyleActionSheet];
         
        UIAlertAction* useCamera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action){
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
                }
            else {
                imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        
        UIAlertAction* usePhotoLibrary = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action){
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imagePickerVC animated:YES completion:nil];
        }];
        
        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
            handler:^(UIAlertAction * action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        
        [alert addAction:useCamera];
        [alert addAction:usePhotoLibrary];
        [alert addAction:cancel];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    [User currentUser].profilePicture = [Activity getPFFileFromImage:editedImage];
    [[User currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self setUpView];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) getUserActivities{
        PFQuery *activityQuery = [Activity query];
        [activityQuery includeKey:@"host"];
        [activityQuery whereKey:@"host" equalTo:self.profileToView];
        [activityQuery orderByDescending:@"createdAt"];
        [activityQuery findObjectsInBackgroundWithBlock:^(NSArray<Activity *> * _Nullable activityObjectArray, NSError * _Nullable error) {
            if (activityObjectArray){
                self.activitiesByUser = activityObjectArray;
            }
            [self.collectionView reloadData];
            [self.refreshControl endRefreshing];
        }];
    }


- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    ActivityCollectionCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"activityCell" forIndexPath:indexPath];
    Activity *activity = self.activitiesByUser[indexPath.row];
    [cell.activityImage setImageWithURL:[NSURL URLWithString:activity.image.url]];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.profileToView.activitiesHosted.count;
}



@end
