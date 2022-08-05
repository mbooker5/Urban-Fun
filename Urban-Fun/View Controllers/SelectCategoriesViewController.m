//
//  SelectCategoriesViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SelectCategoriesViewController.h"

@interface SelectCategoriesViewController () <UITableViewDataSource, UITableViewDelegate, CategoryCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfCategories;

@end

@implementation SelectCategoriesViewController
@synthesize categoriesVCDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getCategories];
}

// fetches category titles from Parse Database
-(void)getCategories{
    
    PFQuery *categoryQuery = [Category query];
    [categoryQuery orderByAscending:@"title"];
    [categoryQuery includeKey:@"title"];
    categoryQuery.limit = 20;

  
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray<Category *> * _Nullable categories, NSError * _Nullable error) {
        if (categories) {
            self.arrayOfCategories = categories;
        }
        else {
        }
        [self.tableView reloadData];
    }];
}

//tableView method
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfCategories.count;
}

//tableView method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];
    cell.categoryCellDelegate = self;
    Category *category = self.arrayOfCategories[indexPath.row];
    cell.category = category;
    cell.indexPath = indexPath;
    [cell setCategoryCell];
    
    if ([self.selectedCategories containsObject:category.title]){
        [cell.checkCategoryButton setSelected:YES];
    }
    else{
        [cell.checkCategoryButton setSelected:NO];
    }
    
    return cell;
}

- (void)didSelectCategory:(nonnull NSIndexPath *)indexPath {
    Category *category = self.arrayOfCategories[indexPath.row];
    if ([self.selectedCategories containsObject:category.title]){
        [self.selectedCategories removeObject:category.title];
    }
    else{
        [self.selectedCategories addObject:category.title];
        }
        
    [self.categoriesVCDelegate setCategoryArray:self.selectedCategories];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
