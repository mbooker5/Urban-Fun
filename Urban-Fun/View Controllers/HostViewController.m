//
//  HostViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/6/22.
//

#import "HostViewController.h"
#import "SelectCategoriesViewController.h"
#import "Activity.h"

@interface HostViewController () <CategoriesViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *activityTitle;
@property (strong, nonatomic) IBOutlet UITextField *activityDescription;
@property (strong, nonatomic) IBOutlet UIImageView *activityImage;
@property (strong, nonatomic) IBOutlet UITextField *minAge;
@property (strong, nonatomic) IBOutlet UITextField *maxAge;
@property (strong, nonatomic) IBOutlet UILabel *errorMessage;


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
    // next four lines convert UITextField text into an NSNumber
    int minAgeInt = [self.minAge.text intValue];
    int maxAgeInt = [self.maxAge.text intValue];
    NSNumber *minimumAge = [NSNumber numberWithInt:minAgeInt];
    NSNumber *maximumAge = [NSNumber numberWithInt:maxAgeInt];
    //
    if (([self.activityTitle hasText]) && ([self.activityDescription hasText])){
    [Activity postUserActivity:(UIImage * _Nullable)_activityImage.image withTitle:(NSString * _Nullable)_activityTitle.text withDescription:(NSString * _Nullable)_activityDescription.text withCategories:(NSMutableArray * _Nullable)self.activityCategories withMinAge:(NSNumber * _Nullable)minimumAge withMaxAge:(NSNumber * _Nullable)maximumAge withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"Post shared successfully!");
    }];
    }
    else{
        self.errorMessage.text = @"Invalid Title/Description";
    }
}

- (void)setCategoryArray:(nonnull NSMutableArray *)selectedCategories {
    self.activityCategories = selectedCategories;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"setCategories"]){
        SelectCategoriesViewController * scVC = [segue destinationViewController];
        scVC.delegate1 = self;
        scVC.selectedCategories = [[NSMutableArray alloc] init];
        scVC.selectedCategories = self.activityCategories;
    }
}





@end


