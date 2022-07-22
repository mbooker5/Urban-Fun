//
//  SignUpViewController.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import "SignUpViewController.h"
#import "HelperClass.h"

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
    
    if ([self.emailField.text isEqualToString:@""]) {
        [HelperClass showAlertWithTitle:@"Enter Email to Register" withMessage:@"Enter valid email address." withActionTitle:@"OK" withHandler:nil  onVC:self];
    }
    if (![self.passwordField.text isEqualToString:self.reEnterPasswordField.text]) {
        [HelperClass showAlertWithTitle:@"Cannot Register User" withMessage:@"Passwords must be the same." withActionTitle:@"OK" withHandler:nil  onVC:self];
        
    }
    else{
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            [HelperClass showAlertWithTitle:@"Cannot Register User" withMessage:[NSString stringWithFormat:@"%@", error.localizedDescription] withActionTitle:@"OK" withHandler:nil  onVC:self];
        }
        else {
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
