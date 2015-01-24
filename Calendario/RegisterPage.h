//
//  RegisterPage.h
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import <UIKit/UIKit.h>

@interface RegisterPage : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *reEnterPasswordField;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTab;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
- (IBAction)doneButton:(id)sender;

@end
