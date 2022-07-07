//
//  Categories.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/7/22.
//

#import "Categories.h"

@implementation Categories
@dynamic categories;
@dynamic category;

+ (nonnull NSString *)parseClassName {
    return @"Categories";
}


NSArray *categories = @[@"Party", @"Club", @"Concert", @"Indoor Sports", @"Outdoor Sports", @"Mental Health", @"Games", @"Video Games", @"Wildlife", @"Tour", @"Bar", @"Practice"];


- (void) newCategories:(NSArray *_Nullable)categories withCompletion:(PFBooleanResultBlock  _Nullable)completion {
    
    Categories *newCategory = [Categories new];
    for(NSString *category in self.categories)
    {
        BOOL isTheObjectThere = [self.categories containsObject:category];
        if (isTheObjectThere == NO){
            newCategory.category = category;
        }
    }
    [newCategory saveInBackgroundWithBlock: completion];
    
}

@end
