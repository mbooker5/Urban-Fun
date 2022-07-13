//
//  HostViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import <UIKit/UIKit.h>
#import "SetCategoryCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface HostViewController : UIViewController
//@property (strong, nonatomic) SetCategoryCell *setCategoryCell;
@property (nonatomic, strong) NSMutableArray *activityCategories;
@end

NS_ASSUME_NONNULL_END
