//
//  TimelineCell.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
NS_ASSUME_NONNULL_BEGIN

@interface TimelineCell : UITableViewCell
@property (strong, nonatomic) Activity *activity;
@end

NS_ASSUME_NONNULL_END
