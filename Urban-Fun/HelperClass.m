//
//  HelperClass.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/22/22.
//

#import "HelperClass.h"

@implementation HelperClass

+ (void)showAlertWithTitle:(NSString *)alertTitle withMessage:(NSString *)alertMessage withActionTitle:(NSString *)actionTitle withHandler:(nullable SEL)func onVC:(UIViewController *)vc {

UIAlertController* alert = [UIAlertController alertControllerWithTitle:alertTitle
                               message:alertMessage
                               preferredStyle:UIAlertControllerStyleAlert];
    if (func == nil){
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action){}];
        [alert addAction:defaultAction];
    }
    else{
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * action){[vc performSelector:func];}];
        [alert addAction:defaultAction];
    }
[vc presentViewController:alert animated:YES completion:nil];
    
}
@end
