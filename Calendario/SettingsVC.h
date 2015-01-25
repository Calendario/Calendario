//
//  SettingsVC.h
//  Calendario
//
//  Created by Larry B. King on 1/25/15.
//
//

#import <UIKit/UIKit.h>

@interface SettingsVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *settingsTableView;

@end
