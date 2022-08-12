//
//  UserCell.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import <UIKit/UIKit.h>
#import "User.h"
NS_ASSUME_NONNULL_BEGIN

@interface UserCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) User *user;
- (void) setUserCell;
@end

NS_ASSUME_NONNULL_END
