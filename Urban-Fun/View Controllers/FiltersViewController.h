//
//  FiltersViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FiltersVCDelegate <NSObject>

- (void)updateFiltersDictionary:(NSMutableDictionary *)filtersDictionary;

@end

@interface FiltersViewController : UIViewController
@property (nonatomic, weak) id <FiltersVCDelegate> filtersVCDelegate;
@property (strong, nonatomic) NSMutableDictionary *filtersDictionary;
@end

NS_ASSUME_NONNULL_END
