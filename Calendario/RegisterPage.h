//
//  RegisterPage.h
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import <UIKit/UIKit.h>

@interface RegisterPage : UIViewController <UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionField;
@property (weak, nonatomic) IBOutlet UITextField *fullNameField;
@property (weak, nonatomic) IBOutlet UITextField *websiteField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTab;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@property (weak, nonatomic) IBOutlet UIScrollView *registerScroll;
- (IBAction)doneButton:(id)sender;
- (IBAction)addImage:(id)sender;

@end
