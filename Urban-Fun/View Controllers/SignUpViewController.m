//
//  SignUpViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *reEnterPasswordField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // dismisses keyboard when tap outside a text field
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [tapGestureRecognizer setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
- (IBAction)registerUser:(id)sender {
    [self registerUser];
}

- (void)registerUser {
    PFUser *newUser = [PFUser user];
    newUser.email = self.emailField.text;
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    
    if ([self.emailField.text isEqual:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Enter Email to Register" message:@"Enter valid email address." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
}];

        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
    
    if (self.passwordField.text != self.reEnterPasswordField.text) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Register User" message:@"Passwords must be the same." preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
}];

        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
    
    
    else{
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Register User" message:[NSString stringWithFormat:@"%@", error.localizedDescription] preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                    
    }];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:^{
            }];
        } else {

            [self performSegueWithIdentifier:@"registerUser" sender:nil];
            
        }
    }];
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
