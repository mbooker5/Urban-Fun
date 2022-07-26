//
//  TimelineCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import "TimelineCell.h"
#import <MapKit/MapKit.h>
#import "ProfileViewController.h"


@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView.layer setBorderColor:[UIColor blackColor].CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CLLocation *)getCLLocation:(PFGeoPoint *)location{
    return [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
}

- (void) setTimelineCell{
    self.activityTitleLabel.text = self.activity.title;
    self.activityDescriptionLabel.text = self.activity.activityDescription;
    self.timelineUsernameLabel.text = [NSString stringWithFormat:@"%@%@", @"@", self.activity.host.username];
    CLLocation *activityLocation = [self getCLLocation:self.activity.location];
    CLLocationDistance distanceFromUser = [self.currentUserLocation distanceFromLocation:activityLocation];
    CLLocationDistance distanceInMiles = distanceFromUser * 0.000621371;
    NSNumber *distanceDouble = [NSNumber numberWithDouble:distanceInMiles];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    if ([distanceDouble intValue] < 10){
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 1;
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        NSString *distanceString = [formatter stringFromNumber:distanceDouble];
        self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    }
    else{
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 0;
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        NSString *distanceString = [formatter stringFromNumber:distanceDouble];
        self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    }
    PFUser *currentUser = [PFUser currentUser];
    if ([self.activity.attendanceList containsObject:currentUser.objectId]){
        [self.timelineJoinButton setSelected:YES];
    }
    else if (![self.activity.attendanceList containsObject:currentUser.objectId]){
        [self.timelineJoinButton setSelected:NO];
    }
}

- (IBAction)didTapFavorite:(id)sender {
}

- (IBAction)didTapJoin:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    if ([self.activity.host.objectId isEqualToString:currentUser.objectId]){
        }
    else{
        [Activity updateAttendanceListWithUserId:currentUser.objectId withActivity:self.activity withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if ([self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.timelineJoinButton setSelected:YES];
            }
            else if (![self.activity.attendanceList containsObject:currentUser.objectId]){
                [self.timelineJoinButton setSelected:NO];
            }
        }];
        
    }
    
}




@end
