//
//  SetCategoriesViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Categories.h"
#import "SetCategoryCell.h"
#import "HostViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CategoriesViewDelegate <NSObject>

- (void)setCategoryArray:(NSMutableArray *)selectedCategories;

@end

@interface SetCategoriesViewController : UIViewController
@property (nonatomic, weak) id <CategoriesViewDelegate> delegate1;
@property (nonatomic, strong) NSMutableArray *selectedCategories;
@end

NS_ASSUME_NONNULL_END
