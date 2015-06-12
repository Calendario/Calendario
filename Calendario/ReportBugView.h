//
//  ReportBugView.h
//  Calendario
//
//  Created by Daniel Sadjadian on 19/02/2015.
//
//

#import <UIKit/UIKit.h>

@interface ReportBugView : UIViewController <UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bugTitle;
@property (weak, nonatomic) IBOutlet UITextView *bugDesc;

-(IBAction)sendBugReport:(id)sender;

@end
