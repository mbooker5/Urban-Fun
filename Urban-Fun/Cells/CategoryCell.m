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
    [self.categoryCellDelegate didSelectCategory:self.indexPath];

}






-(void)setCategoryCell{
    self.categoryLabel.text = self.category.title;
}
@end
