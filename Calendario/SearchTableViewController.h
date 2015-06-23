//
//  SearchTableViewController.h
//  Calendario
//
//  Created by Daniel Sadjadian on 13/06/2015.
//
//

#import <UIKit/UIKit.h>
#import "SearchCell.h"

@class SearchCell;
@interface SearchTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *searchTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
