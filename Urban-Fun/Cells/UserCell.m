//
//  UserCell.m
//  Urban-Fun
//
//  Created by Maize Booker on 7/28/22.
//

#import "UserCell.h"
#import "UIImageView+AFNetworking.h"

@implementation UserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
}

-(void) setUserCell{
    self.usernameLabel.text = self.user.username;
    if (self.user.profilePicture.url){
        [self.profilePicture setImageWithURL:[NSURL URLWithString:self.user.profilePicture.url]];
    }
    else{
        self.profilePicture.image = [UIImage imageNamed:@"Urban Fun"];
    }
    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height/2.0;;
    self.profilePicture.clipsToBounds = YES;
}

@end
