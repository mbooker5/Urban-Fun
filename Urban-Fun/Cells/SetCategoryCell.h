//
//  SetCategoryCell.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "PFObject.h"
#import "Categories.h"
#import "Parse/ParseUIConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) Categories *category;
@property (strong, nonatomic) IBOutlet UIButton *checkCategoryButton;

- (void) setCell;
@end

NS_ASSUME_NONNULL_END
