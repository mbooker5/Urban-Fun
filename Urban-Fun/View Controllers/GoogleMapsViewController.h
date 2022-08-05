//
//  GoogleMapsViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 8/4/22.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import <MapKit/MapKit.h>
#import "HelperClass.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoogleMapsViewController : UIViewController
@property (nonatomic, strong) Activity *activity;
@end

NS_ASSUME_NONNULL_END
