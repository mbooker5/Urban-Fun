//
//  Categories.h
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "PFObject.h"
#import "Parse/Parse.h"
NS_ASSUME_NONNULL_BEGIN

@interface Category : PFObject<PFSubclassing>
@property (nonatomic, strong) NSString *title;
@end

NS_ASSUME_NONNULL_END
