//
//  StatusUpdateViewController.h
//  Calendario
//
//  Created by Derek Cacciotti on 9/25/15.
//
//

#import <UIKit/UIKit.h>

@interface StatusUpdateViewController : UIViewController



@property (weak, nonatomic) IBOutlet UILabel *UpdateLabel;

@property (weak, nonatomic) IBOutlet UITextField *statusTextField;

- (IBAction)PostUpdate:(id)sender;



@end
