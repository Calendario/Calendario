//
//  HomeViewController.h
//  Calendario
//
//  Created by Harith Bakri on 11/25/14.
//
//

#import <UIKit/UIKit.h>
#import "FollowUserAccount.h"

@interface HomeViewController : UIViewController {
    
    FollowUserAccount *userData;
}

// Testing.... TEMPORARY ONLY...
-(IBAction)open_profile:(id)sender;
-(IBAction)followUserTEST:(id)sender;

@property (nonatomic, retain) FollowUserAccount *userData;

@end
