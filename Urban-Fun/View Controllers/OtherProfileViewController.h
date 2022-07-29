//
//  OtherProfileViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFObject.h"
#import "Parse/ParseUIConstants.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface OtherProfileViewController : UIViewController
@property (strong, nonatomic) User *profileToView;
@end

NS_ASSUME_NONNULL_END
