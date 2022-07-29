//
//  ActivityDetailsViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "Activity.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "Parse/ParseUIConstants.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ActivityDetailsDelegate <NSObject>

- (void)syncButtons;

@end

@interface ActivityDetailsViewController : UIViewController
@property (nonatomic, weak) id <ActivityDetailsDelegate> activitydetailsDelegate;
@property (nonatomic, strong) Activity *activity;

@end

NS_ASSUME_NONNULL_END
