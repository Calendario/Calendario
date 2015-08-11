//
//  FollowersView.h
//  Calendario
//
//  Created by Daniel Sadjadian on 20/07/2015.
//
//

#import <UIKit/UIKit.h>
#import "FollowerCell.h"

@class FollowerCell;
@interface FollowersView : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *followersList;

@end
