//
//  SetCategoriesViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SetCategoriesViewController.h"

@interface SetCategoriesViewController () <UITableViewDataSource, UITableViewDelegate, CategoryCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfCategories;

@end

@implementation SetCategoriesViewController
@synthesize delegate1;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self getCategories];
    [self.tableView reloadData];
    
    
}

// fetches category titles from Parse Database
-(void)getCategories{

    PFQuery *categoryQuery = [Categories query];
    [categoryQuery orderByAscending:@"title"];
    [categoryQuery includeKey:@"title"];
    categoryQuery.limit = 20;

  
    [categoryQuery findObjectsInBackgroundWithBlock:^(NSArray<Categories *> * _Nullable categories, NSError * _Nullable error) {
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
    SetCategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetCategoryCell" forIndexPath:indexPath];
    cell.delegate = self;
    Categories *category = self.arrayOfCategories[indexPath.row];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)didSelectCategory:(nonnull NSIndexPath *)indexPath {
    Categories *category = self.arrayOfCategories[indexPath.row];
    if ([self.selectedCategories containsObject:category.title]){
        [self.selectedCategories removeObject:category.title];
        NSLog(@"removed");
    }
    else{
        [self.selectedCategories addObject:category.title];
        NSLog(@"%@ added", category.title);
        }
        
    NSLog(@"current categories: %@", self.selectedCategories);
    [self.delegate1 setCategoryArray:self.selectedCategories];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
