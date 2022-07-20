//
//  ActivityDetailsViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/18/22.
//

#import "ActivityDetailsViewController.h"

@interface ActivityDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *detailsTitle;
@property (strong, nonatomic) IBOutlet UILabel *detailsHostLabel;

@end

@implementation ActivityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.detailsTitle.text = self.activity.title;
    self.detailsHostLabel.text = [NSString stringWithFormat:@"%@%@", @"Host: ", self.activity.host.username];
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
