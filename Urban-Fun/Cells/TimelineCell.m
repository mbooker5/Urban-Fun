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
}
@end
