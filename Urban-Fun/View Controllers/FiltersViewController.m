//
//  FiltersViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import "FiltersViewController.h"

@interface FiltersViewController ()
@property (strong, nonatomic) IBOutlet UISlider *distanceSlider;
@property (strong, nonatomic) NSMutableDictionary *filtersDictionary;
@end

@implementation FiltersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)distanceChanged:(id)sender {
    _distanceSlider.value = roundf(_distanceSlider.value);
    if (_distanceSlider.value == 1){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:5];
    }
    if (_distanceSlider.value == 2){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:10];
    }
    if (_distanceSlider.value == 3){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:20];
    }
    if (_distanceSlider.value == 4){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:30];
    }
    if (_distanceSlider.value == 5){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:40];
    }
    if (_distanceSlider.value == 6){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:50];
    }
    if (_distanceSlider.value == 7){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:75];
    }
    if (_distanceSlider.value == 8){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:100];
    }
    if (_distanceSlider.value == 9){
        _filtersDictionary[@"distance"] = [NSNumber numberWithInt:200];
    }
    if (_distanceSlider.value == 10){
        _filtersDictionary[@"distance"] = nil;
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
