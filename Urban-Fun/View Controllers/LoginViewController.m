//
//  LoginViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // dismiss keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}


- (IBAction)loginUser:(id)sender {
    [self loginUser];
}


- (void)loginUser {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"User Login Failed" message:[NSString stringWithFormat:@"%@", error.localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                                
    }];
      
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{

            }];
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            // makes segue to ChatViewController
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
            NSLog(@"User logged in successfully");
            

        }
    }];
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
