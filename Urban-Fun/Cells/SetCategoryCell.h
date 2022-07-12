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
#import "HostViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CategoryCellDelegate <NSObject>

- (void)didSelectCategory:(NSIndexPath *)indexPath;

@end

@interface SetCategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) Categories *category;
@property (strong, nonatomic) IBOutlet UIButton *checkCategoryButton;
@property (nonatomic, weak) id <CategoryCellDelegate> delegate;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void) setCell;
//@property (nonatomic, strong) NSMutableArray *activityCategories;
@end

NS_ASSUME_NONNULL_END
