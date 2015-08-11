//
//  FollowerCell.h
//  Calendario
//
//  Created by Daniel Sadjadian on 21/07/2015.
//
//

#import <UIKit/UIKit.h>

@interface FollowerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *followingCheck;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedRibbon;

@end
