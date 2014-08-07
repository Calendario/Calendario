//
//  RegisterViewController.h
//  Calendario
//
//  Created by Harith Bakri on 8/7/14.
//
//

#import <Foundation/Foundation.h>

@interface RegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *DoneButton;
@property (weak, nonatomic) IBOutlet UITextField *EmailaddressField;
@property (weak, nonatomic) IBOutlet UITextField *UserNameField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordField;
@property (weak, nonatomic) IBOutlet UITextField *ReenterpasswordField;


- (IBAction)DoneButton:(id)sender;

@end
