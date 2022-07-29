//
//  TimelineCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import "TimelineCell.h"
#import <MapKit/MapKit.h>



@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    CLLocation *activityLocation = [self getCLLocationForGeoPoint:self.activity.location];
    CLLocationDistance distanceFromUser = [self.currentUserLocation distanceFromLocation:activityLocation];
    CLLocationDistance distanceInMiles = distanceFromUser * 0.000621371;
    NSNumber *distanceDouble = [NSNumber numberWithDouble:distanceInMiles];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = [distanceDouble intValue] < 10 ? 1 : 0;
    formatter.roundingMode = NSNumberFormatterRoundHalfUp;
    NSString *distanceString = [formatter stringFromNumber:distanceDouble];
    self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    
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

- (IBAction)tappedUsername:(id)sender {
    [self.timelineCellDelegate didTapUsername:self.activity.host];
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
