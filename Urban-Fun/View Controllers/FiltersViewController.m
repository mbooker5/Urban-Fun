//
//  FiltersViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import "FiltersViewController.h"
#import "HelperClass.h"

@interface FiltersViewController () <CategoriesViewDelegate>
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *distanceSliderLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectCategoriesButton;
@property (strong, nonatomic) IBOutlet UILabel *selectCategoriesLabel;
@property (strong, nonatomic) IBOutlet UITextField *minAgeTF;
@property (strong, nonatomic) IBOutlet UITextField *maxAgeTF;
@property (strong, nonatomic) IBOutlet UISlider *availabilitySlider;
@property (strong, nonatomic) IBOutlet UILabel *availabilitySliderLabel;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // dismisses keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    if (self.filtersDictionary[kDistanceSliderValue] != nil){
        [self.distanceSlider setValue:[self.filtersDictionary[kDistanceSliderValue] floatValue]];
    }
    else{
        [self.distanceSlider setValue:10.0];
    }
    
    if (self.filtersDictionary[kAvailability] != nil){
        [self.availabilitySlider setValue:[self.filtersDictionary[kAvailability] floatValue]];
    }
    else{
        [self.availabilitySlider setValue:31.0];
    }
    
    [self setDistanceSliderLabel];
    [self setSelectCategoriesLabel];
    [self setMinAgeTF];
    [self setMaxAgeTF];
    [self setAvailabilitySliderLabel];
}

- (IBAction)startedEditingMinAge:(id)sender {
    self.minAgeTF.text = @"";
}


- (IBAction)didEditMinAge:(id)sender {
    if ([self.minAgeTF hasText]){
        self.filtersDictionary[kMinimumAge] = [NSNumber numberWithInt:[self.minAgeTF.text intValue]];
        if ([self.maxAgeTF hasText]){
            if ([self.maxAgeTF.text intValue] < [self.minAgeTF.text intValue]){
                self.filtersDictionary[kMaximumAge] = nil;
                self.maxAgeTF.text = @"Any";
            }
        }
    }
    else{
        self.filtersDictionary[kMinimumAge] = nil;
        self.minAgeTF.text = @"Any";
    }
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)startedEditingMaxAge:(id)sender {
    self.maxAgeTF.text = @"";
}

- (IBAction)didEditMaxAge:(id)sender {
    if ([self.maxAgeTF hasText]){
        self.filtersDictionary[kMaximumAge] = [NSNumber numberWithInt:[self.maxAgeTF.text intValue]];
        if ([self.minAgeTF hasText]){
            if ([self.minAgeTF.text intValue] > [self.maxAgeTF.text intValue]){
                self.filtersDictionary[kMinimumAge] = nil;
                self.minAgeTF.text = @"Any";
            }
        }
    }
    else{
        self.filtersDictionary[kMaximumAge] = nil;
        self.maxAgeTF.text = @"Any";
    }
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)availabilityChanged:(id)sender {
    float sliderValue = floorf(self.availabilitySlider.value);
    
    if (sliderValue < 31){
        self.filtersDictionary[kAvailability] = [NSNumber numberWithFloat:sliderValue];
        
    }
    else{
        self.filtersDictionary[kAvailability] = nil;
    }
    [self setAvailabilitySliderLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}


- (IBAction)distanceChanged:(id)sender {
    NSArray<NSNumber *> *const mDistances = @[@5, @10, @20, @30, @40, @50, @75, @100, @200];
    float sliderValue = floorf(self.distanceSlider.value);
    
    if (sliderValue < 10){
        self.filtersDictionary[kDistance] = mDistances[(int)sliderValue - 1];
        self.filtersDictionary[kDistanceSliderValue] = [NSNumber numberWithFloat:sliderValue];
    }
    else{
        self.filtersDictionary[kDistance] = nil;
        self.filtersDictionary[kDistanceSliderValue] = nil;
    }
    
    [self setDistanceSliderLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)didTapCategories:(id)sender {
    [self performSegueWithIdentifier:@"categoriesFromFilters" sender:sender];
}

- (void) setDistanceSliderLabel{
    if (self.filtersDictionary[kDistance] != nil){
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Within ", self.filtersDictionary[kDistance], @" miles" ];
    }
    else{
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@", @"Any"];
    }
}

- (void) setSelectCategoriesLabel{
    if (self.filtersDictionary[kCategoriesCount] > 0){
        self.selectCategoriesLabel.text = [NSString stringWithFormat:@"%@%@", self.filtersDictionary[kCategoriesCount], @" selected"];
    }
    else{
        self.selectCategoriesLabel.text = @"Select";
    }
}

- (void) setMinAgeTF{
    if (self.filtersDictionary[kMinimumAge] != nil){
        self.minAgeTF.text = [NSString stringWithFormat:@"%@", self.filtersDictionary[kMinimumAge]];
    }
    else{
        self.minAgeTF.text = @"Any";
    }
}

- (void) setMaxAgeTF{
    if (self.filtersDictionary[kMaximumAge] != nil){
        self.maxAgeTF.text = [NSString stringWithFormat:@"%@", self.filtersDictionary[kMaximumAge]];
    }
    else{
        self.maxAgeTF.text = @"Any";
    }
}

- (void) setAvailabilitySliderLabel{
    if (self.filtersDictionary[kAvailability] != nil){
        self.availabilitySliderLabel.text = [NSString stringWithFormat:@"%@%@", self.filtersDictionary[kAvailability], @"+" ];
    }
    else{
        self.availabilitySliderLabel.text = [NSString stringWithFormat:@"%@", @"Any"];
    }
}


- (void)setCategoryArray:(nonnull NSMutableArray *)selectedCategories {
    if (selectedCategories.count > 0){
        self.filtersDictionary[kCategories] = selectedCategories;
        self.filtersDictionary[kCategoriesCount] = [NSNumber numberWithUnsignedLong:selectedCategories.count];
    }
    else{
        self.filtersDictionary[kCategories] = [[NSMutableArray alloc] init];
        self.filtersDictionary[kCategoriesCount] = 0;
    }
    [self setSelectCategoriesLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
}

- (IBAction)didTapReset:(id)sender {
    self.filtersDictionary[kDistance] = nil;
    self.filtersDictionary[kDistanceSliderValue] = nil;
    self.filtersDictionary[kCategories] = [[NSMutableArray alloc] init];
    self.filtersDictionary[kCategoriesCount] = 0;
    self.filtersDictionary[kMinimumAge] = nil;
    self.filtersDictionary[kMaximumAge] = nil;
    self.filtersDictionary[kAvailability] = nil;
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
    [self viewDidLoad];
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"categoriesFromFilters"]){
        SelectCategoriesViewController *selectCategoriesVC = [segue destinationViewController];
        selectCategoriesVC.categoriesVCDelegate = self;
        selectCategoriesVC.selectedCategories = self.filtersDictionary[kCategories];
    }
}


@end
