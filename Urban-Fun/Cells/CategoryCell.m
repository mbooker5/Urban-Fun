//
//  SetCategoryCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

//handles category cell being tapped
- (IBAction)didTapCell:(id)sender {
    
//    [self.delegate didSelectCategory:self.category.title];
    [self.delegate didSelectCategory:self.indexPath];

}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCategoryCell{
    
    self.categoryLabel.text = self.category.title;
//    self.checkCategoryButton.titleLabel = self.category.title;
}
@end
