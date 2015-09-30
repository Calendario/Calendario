//
//  ProfilePage.h
//  Calendario
//
//  Created by Daniel Sadjadian on 18/05/2015.
//
//

#import <UIKit/UIKit.h>

@interface ProfilePage : UIViewController 

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UIImageView *verifiedRibbon;

@property (weak, nonatomic) IBOutlet UIButton *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *userWebsite;

@property (weak, nonatomic) IBOutlet UILabel *postsLoadedBy;
@property (weak, nonatomic) IBOutlet UILabel *postCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followerCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *followingCountLabel;

-(IBAction)editUserProfile:(id)sender;
-(IBAction)openUserWebsite:(id)sender;

@end

