//
//  AttendanceViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/26/22.
//

#import <UIKit/UIKit.h>
#import "TimelineViewController.h"
#import "Activity.h"
#import "Parse/Parse.h"
#import "PFObject.h"
#import "Parse/ParseUIConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceViewController : UIViewController
@property (nonatomic, strong) Activity *activity;
@end

NS_ASSUME_NONNULL_END
