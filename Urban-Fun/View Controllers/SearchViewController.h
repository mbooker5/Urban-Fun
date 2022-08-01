//
//  SearchViewController.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/5/22.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Activity.h"
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : UIViewController
@property (nonatomic, strong) NSArray<User *> *usersArray;
@property (nonatomic, strong) NSArray<Activity *> *activitiesArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
