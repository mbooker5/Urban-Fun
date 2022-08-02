//
//  TimelineCell.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import <UIKit/UIKit.h>
#import "Activity.h"

NS_ASSUME_NONNULL_BEGIN

@protocol TimelineCellDelegate <NSObject>

- (void)didTapUsername:(User *)user;

@end

@interface TimelineCell : UITableViewCell
@property (nonatomic, weak) id <TimelineCellDelegate> timelineCellDelegate;
@property (strong, nonatomic) Activity *activity;
@property (strong, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (nonatomic, strong) CLLocation *currentUserLocation;
@property (strong, nonatomic) IBOutlet UILabel *activityDistanceLabel;
@property (strong, nonatomic) IBOutlet UIButton *usernameButton;
- (void) setTimelineCell;
@property (strong, nonatomic) IBOutlet UIButton *timelineFavoriteButton;
@property (strong, nonatomic) IBOutlet UILabel *timelineUsernameLabel;
@property (strong, nonatomic) IBOutlet UIButton *timelineJoinButton;
@property (strong, nonatomic) IBOutlet NSNumber *distanceDouble;
@end

NS_ASSUME_NONNULL_END
