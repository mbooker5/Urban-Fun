//
//  HostViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "CategoryCell.h"


NS_ASSUME_NONNULL_BEGIN
@class Activity;


@interface HostViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *activityCategories;
@end

NS_ASSUME_NONNULL_END
