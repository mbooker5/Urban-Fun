//
//  HostViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "HostViewController.h"
#import "SetCategoriesViewController.h"
#import "Activity.h"

@interface HostViewController () <CategoriesViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
@property (strong, nonatomic) IBOutlet UITextField *activityDescription;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;

@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.activityCategories = [[NSMutableArray alloc] init];
    // dismiss keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}



- (IBAction)uploadActivity:(id)sender {
//    SetCategoryCell *setCategoryCell = [[SetCategoryCell alloc] init];
    [Activity postUserActivity:(UIImage * _Nullable)_activityImage.image withTitle:(NSString * _Nullable)_activityTitle.text withDescription:(NSString * _Nullable)_activityDescription.text withCategories:(NSMutableArray * _Nullable)self.activityCategories withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"Post shared successfully!");
    }];
}

- (void)setCategoryArray:(nonnull NSMutableArray *)selectedCategories {
    self.activityCategories = selectedCategories;
    NSLog(@"activityCategories: %@", self.activityCategories);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"setCategories"]){
        SetCategoriesViewController * scVC = [segue destinationViewController];
        scVC.delegate1 = self;
        scVC.selectedCategories = [[NSMutableArray alloc] init];
        scVC.selectedCategories = self.activityCategories;
        NSLog(@"HOST VC Categories: %@", self.activityCategories);
    }
}


@end


