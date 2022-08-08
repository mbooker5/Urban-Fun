//
//  TimelineCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import "TimelineCell.h"
#import <MapKit/MapKit.h>
#import "HelperClass.h"
#import "UIImageView+AFNetworking.h"



@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.shimmeringView.contentView = self.activityTitleLabel;
    self.shimmeringView.shimmering = YES;
    self.validationView.alpha = 0.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CLLocation *)getCLLocationForGeoPoint:(PFGeoPoint *)location{
    return [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
}

- (void) setTimelineCell{
    self.activityTitleLabel.text = self.activity.title;
    self.activityDescriptionLabel.text = self.activity.activityDescription;
    self.timelineUsernameLabel.text = [NSString stringWithFormat:@"%@%@", @"@", self.activity.host.username];
    NSNumber *distance = [HelperClass distanceFromUserLocation:self.currentUserLocation forActivity:self.activity];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = [distance intValue] < 10 ? 1 : 0;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    NSString *distanceString = [formatter stringFromNumber:distance];
    self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    
    PFUser *currentUser = [PFUser currentUser];
    if ([self.activity.attendanceList containsObject:currentUser.objectId]){
        [self.timelineJoinButton setSelected:YES];
    }
    else if (![self.activity.attendanceList containsObject:currentUser.objectId]){
        [self.timelineJoinButton setSelected:NO];
    }
    self.activityImage.layer.cornerRadius = 5.0;
    self.activityImage.clipsToBounds = YES;
    self.validationView.layer.cornerRadius = 5.0;
    self.validationView.clipsToBounds = YES;
    [self.activityImage setImageWithURL:[NSURL URLWithString:self.activity.image.url]];
}

- (IBAction)didTapFavorite:(id)sender {
}

- (IBAction)tappedUsername:(id)sender {
    [self.timelineCellDelegate didTapUsername:self.activity.host];
}

- (IBAction)didTapDistance:(id)sender {
    [self.timelineCellDelegate didTapDistance:self.activity];
}


- (IBAction)didTapJoin:(id)sender {
    User *currentUser = [User currentUser];
    if (![self.activity.host.objectId isEqualToString:currentUser.objectId]){
        [Activity updateAttendanceListWithUserId:currentUser.objectId withActivity:self.activity withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if ([self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.timelineJoinButton setSelected:YES];
                [UIView animateWithDuration:4.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    if ([self.activity.maxUsers intValue] > 0){
                        if (([self.activity.attendanceList indexOfObject:currentUser.objectId] + 1 <= [self.activity.maxUsers intValue])){
                            self.validationView.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:168.0/255.0 blue:68.0/255.0 alpha:0.9];
                            self.validationView.alpha = 1.0;
                            self.validationView.alpha = 0.0;
                        }
                        else{
                            self.validationView.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:250.0/255.0 blue:5.0/255.0 alpha:0.9];
                            self.validationView.alpha = 1.0;
                            self.validationView.alpha = 0.0;
                        }
                    }
                    self.validationView.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:168.0/255.0 blue:68.0/255.0 alpha:0.9];
                    self.validationView.alpha = 1.0;
                    self.validationView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.validationView.backgroundColor = [UIColor colorWithRed:50.0/255.0 green:168.0/255.0 blue:68.0/255.0 alpha:0];
                }];
            }
            else if (![self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.timelineJoinButton setSelected:NO];
            }
        }];
    }
}


@end
