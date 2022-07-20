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
    [self.contentView.layer setBorderColor:(__bridge CGColorRef _Nullable)([UIColor colorNamed:@"Black"])];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- getCLLocation:(PFGeoPoint *)location{
    return [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
}

- (void) setTimelineCell{
    self.activityTitleLabel.text = self.activity.title;
    self.activityDescriptionLabel.text = self.activity.activityDescription;
    CLLocation *activityLocation = [self getCLLocation:self.activity.location];
    CLLocationDistance distanceFromUser = [self.currentUserLocation distanceFromLocation:activityLocation];
    CLLocationDistance distanceInMiles = distanceFromUser * 0.000621371;
    NSNumber *distanceDouble = [NSNumber numberWithDouble:distanceInMiles];
    if ([distanceDouble intValue] < 10){
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 1;
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        NSString *distanceString = [formatter stringFromNumber:distanceDouble];
        self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    }
    else{
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.maximumFractionDigits = 0;
        formatter.roundingMode = NSNumberFormatterRoundHalfUp;
        NSString *distanceString = [formatter stringFromNumber:distanceDouble];
        self.activityDistanceLabel.text = [[NSString alloc] initWithFormat: @"%@%@", distanceString, @" mi"];
    }
}
@end
