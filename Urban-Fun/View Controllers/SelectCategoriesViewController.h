//
//  SelectCategoriesViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "Category.h"
#import "CategoryCell.h"
#import "HostViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol CategoriesViewDelegate <NSObject>

- (void)setCategoryArray:(NSMutableArray *)selectedCategories;

@end

@interface SelectCategoriesViewController : UIViewController
@property (nonatomic, weak) id <CategoriesViewDelegate> categoriesVCDelegate;
@property (nonatomic, strong) NSMutableArray *selectedCategories;
@end

NS_ASSUME_NONNULL_END
