//
//  SetCategoriesViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "SetCategoriesViewController.h"

@interface SetCategoriesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *arrayOfCategories;
@end

@implementation SetCategoriesViewController

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
    return self.arrayOfCategories.count; //
}

//tableView method
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SetCategoryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SetCategoryCell" forIndexPath:indexPath];
    
    Categories *category = self.arrayOfCategories[indexPath.row];
    cell.category = category;
    [cell setCell];

    
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

@end
