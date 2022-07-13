//
//  TimelineCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/11/22.
//

#import "TimelineCell.h"

@implementation TimelineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) setTimelineCell{
    self.activityTitleLabel.text = self.activity.title;
    self.activityDescriptionLabel.text = self.activity.activityDescription;
}
@end
