//
//  ReportBugView.h
//  Calendario
//
//  Created by Daniel Sadjadian on 19/02/2015.
//
//

#import <UIKit/UIKit.h>

@interface ReportBugView : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *reportBugTableView;

@end
