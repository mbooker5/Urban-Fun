//
//  FiltersViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) IBOutlet UILabel *distanceSliderLabel;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.filtersDictionary[@"distanceSliderValue"] != nil){
        [self.distanceSlider setValue:[self.filtersDictionary[@"distanceSliderValue"] floatValue]];
    }
    else{
        [self.distanceSlider setValue:10.0];
    }
    [self setDistanceSliderLabel];
}

- (IBAction)distanceChanged:(id)sender {
    float sliderValue = floorf(self.distanceSlider.value);
    NSLog(@"%f", sliderValue);
    
    if (sliderValue == 1){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:5];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:1];
    }
    if (sliderValue == 2){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:10];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:2];
    }
    if (sliderValue == 3){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:20];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:3];
    }
    if (sliderValue == 4){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:30];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:4];
    }
    if (sliderValue == 5){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:40];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:5];
    }
    if (sliderValue == 6){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:50];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:6];
    }
    if (sliderValue == 7){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:75];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:7];
    }
    if (sliderValue == 8){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:100];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:8];
    }
    if (sliderValue == 9){
        self.filtersDictionary[@"distance"] = [NSNumber numberWithInt:200];
        self.filtersDictionary[@"distanceSliderValue"] = [NSNumber numberWithInt:9];
    }
    if (sliderValue == 10){
        self.filtersDictionary[@"distance"] = nil;
        self.filtersDictionary[@"distanceSliderValue"] = nil;
    }
    [self setDistanceSliderLabel];
    [self.filtersVCDelegate updateFiltersDictionary:self.filtersDictionary];
    NSLog(@"%@", self.filtersDictionary[@"distance"]);
}

- (void) setDistanceSliderLabel{
    if (self.filtersDictionary[@"distance"] != nil){
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@%@%@", @"Within ", self.filtersDictionary[@"distance"], @" miles" ];
    }
    else{
        self.distanceSliderLabel.text = [NSString stringWithFormat:@"%@", @"Any"];
    }
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
