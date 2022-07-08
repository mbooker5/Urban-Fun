//
//  SetCategoryCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SetCategoryCell.h"

@implementation SetCategoryCell
- (IBAction)didTapCell:(id)sender {
    [self.checkCategoryButton setSelected:YES];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCell{

    self.categoryLabel.text = self.category.title;
    
}
@end
