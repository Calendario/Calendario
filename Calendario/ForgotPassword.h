//
//  ForgotPassword.h
//  Calendario
//
//  Created by Harith Bakri on 3/18/15.
//
//

#import <UIKit/UIKit.h>

@interface ForgotPassword : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtEmailaddress;


- (IBAction)fowardClicked:(id)sender;

- (IBAction)backgroundTap:(id)sender;

@end
