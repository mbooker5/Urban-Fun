//
//  HelperClass.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/22/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelperClass : NSObject
+ (void)showAlertWithTitle:(NSString *)alertTitle withMessage:(NSString *)alertMessage withActionTitle:(NSString *)actionTitle withHandler:(nullable SEL)func onVC:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
