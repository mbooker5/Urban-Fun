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

@protocol HostVCDelegate <NSObject>

- (void) didPostActivity:(Activity *)activity;

@end

@interface HostViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *activityCategories;
@property (nonatomic, weak) id <HostVCDelegate> hostVCDelegate;
@end

NS_ASSUME_NONNULL_END
