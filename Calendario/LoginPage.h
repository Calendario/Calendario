//
//  LoginPage.h
//  Calendario
//
//  Created by Harith Bakri on 11/25/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <GooglePlus/GooglePlus.h>

@interface LoginPage : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;


- (IBAction)signinClicked:(id)sender;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *backgroundTab;

- (IBAction)backgroundTab:(id)sender;
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@end
