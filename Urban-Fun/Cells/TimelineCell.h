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
@property (strong, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
- (void) setTimelineCell;
@end

NS_ASSUME_NONNULL_END
