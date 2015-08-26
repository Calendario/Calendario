//
//  EditProfile.h
//  Calendario
//
//  Created by Daniel Sadjadian on 26/08/2015.
//
//

#import <UIKit/UIKit.h>

@interface EditProfile : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    
    NSString *passInID;
    NSString *passInPass;
}

@property (nonatomic, retain) NSString *passInID;
@property (nonatomic, retain) NSString *passInPass;

@property (weak, nonatomic) IBOutlet UITextField *userFullName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UITextField *userDescription;
@property (weak, nonatomic) IBOutlet UITextField *userWebsiteURL;
@property (weak, nonatomic) IBOutlet UITextField *userEmailAddress;
@property (weak, nonatomic) IBOutlet UIScrollView *profileScroll;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;

-(IBAction)saveUserEdits:(id)sender;
-(IBAction)editUserImage:(id)sender;
-(IBAction)goBack:(id)sender;

@end
