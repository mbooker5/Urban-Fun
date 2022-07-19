//
//  ActivityDetailsViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/18/22.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "Activity.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivityDetailsViewController : UIViewController
@property (nonatomic, strong) Activity *activity;

@end

NS_ASSUME_NONNULL_END
