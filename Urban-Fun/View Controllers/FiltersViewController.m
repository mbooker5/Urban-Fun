//
//  FiltersViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import "FiltersViewController.h"

@interface FiltersViewController () <CategoriesViewDelegate>
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *distanceSliderLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectCategoriesButton;
@property (strong, nonatomic) IBOutlet UILabel *selectCategoriesLabel;
@property (strong, nonatomic) IBOutlet UITextField *minAgeTF;
@property (strong, nonatomic) IBOutlet UITextField *maxAgeTF;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // dismisses keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if (self.filtersDictionary[@"distanceSliderValue"] != nil){
        [self.distanceSlider setValue:[self.filtersDictionary[@"distanceSliderValue"] floatValue]];
    }
    else{
        [self.distanceSlider setValue:10.0];
    }
    [self setDistanceSliderLabel];
    [self setSelectCategoriesLabel];
    [self setMinAgeTF];
    [self setMaxAgeTF];
    
}

- (IBAction)didEditMinAge:(id)sender {
    if ([self.minAgeTF hasText]){
        self.filtersDictionary[@"minimumAge"] = [NSNumber numberWithInt:[self.minAgeTF.text intValue]];
        if ([self.maxAgeTF hasText]){
            if ([self.maxAgeTF.text intValue] < [self.minAgeTF.text intValue]){
                self.filtersDictionary[@"maximumAge"] = nil;
                self.maxAgeTF.text = @"Any";
            }
        }
    }
    else{
        self.filtersDictionary[@"minimumAge"] = nil;
        self.minAgeTF.text = @"Any";
    }
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)didEditMaxAge:(id)sender {
    if ([self.maxAgeTF hasText]){
        self.filtersDictionary[@"maximumAge"] = [NSNumber numberWithInt:[self.maxAgeTF.text intValue]];
        if ([self.minAgeTF hasText]){
            if ([self.minAgeTF.text intValue] > [self.maxAgeTF.text intValue]){
                self.filtersDictionary[@"minimumAge"] = nil;
                self.minAgeTF.text = @"Any";
            }
        }
    }
    else{
        self.filtersDictionary[@"maximumAge"] = nil;
        self.maxAgeTF.text = @"Any";
    }
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}


- (IBAction)distanceChanged:(id)sender {
    NSArray<NSNumber *> *const mDistances = @[@5, @10, @20, @30, @40, @50, @75, @100, @200];
    float sliderValue = floorf(self.distanceSlider.value);
    
    if (sliderValue < 10){
        self.filtersDictionary[@"distance"] = mDistances[(int)sliderValue - 1];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithFloat:sliderValue];
    }
    else{
        self.filtersDictionary[@"distance"] = nil;
        self.filtersDictionary[@"distanceSliderValue"] = nil;
    }
    
    [self setDistanceSliderLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)didTapCategories:(id)sender {
    [self performSegueWithIdentifier:@"categoriesFromFilters" sender:sender];
}

- (void) setDistanceSliderLabel{
    if (self.filtersDictionary[@"distance"] != nil){
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Within ", self.filtersDictionary[@"distance"], @" miles" ];
    }
    else{
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@", @"Any"];
    }
}

- (void) setSelectCategoriesLabel{
    if (self.filtersDictionary[@"categoriesCount"] > 0){
        self.selectCategoriesLabel.text = [NSString stringWithFormat:@"%@%@", self.filtersDictionary[@"categoriesCount"], @" selected"];
    }
    else{
        self.selectCategoriesLabel.text = @"Select";
    }
}

- (void) setMinAgeTF{
    if (self.filtersDictionary[@"minimumAge"] != nil){
        self.minAgeTF.text = [NSString stringWithFormat:@"%@", self.filtersDictionary[@"minimumAge"]];
    }
    else{
        self.minAgeTF.text = @"Any";
    }
}

- (void) setMaxAgeTF{
    if (self.filtersDictionary[@"maximumAge"] != nil){
        self.maxAgeTF.text = [NSString stringWithFormat:@"%@", self.filtersDictionary[@"maximumAge"]];
    }
    else{
        self.maxAgeTF.text = @"Any";
    }
}


- (void)setCategoryArray:(nonnull NSMutableArray *)selectedCategories {
    if (selectedCategories.count > 0){
        self.filtersDictionary[@"categories"] = selectedCategories;
        self.filtersDictionary[@"categoriesCount"] = [NSNumber numberWithUnsignedLong:selectedCategories.count];
    }
    else{
        self.filtersDictionary[@"categories"] = [[NSMutableArray alloc] init];
        self.filtersDictionary[@"categoriesCount"] = 0;
    }
    [self setSelectCategoriesLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"categoriesFromFilters"]){
        SelectCategoriesViewController *selectCategoriesVC = [segue destinationViewController];
        selectCategoriesVC.categoriesVCDelegate = self;
        selectCategoriesVC.selectedCategories = self.filtersDictionary[@"categories"];
    }
}


@end
