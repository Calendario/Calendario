//
//  NotificationsViewController.h
//  Calendario
//
//  Created by Larry B. King on 2/12/15.
//
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *notificationsTableView;

@end
