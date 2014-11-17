//
//  ExempleViewController.m
//  Calendario
//
//  Created by Harith Bakri on 6/12/14.
//
//

#import "ExempleViewController.h"
#import "UserDAO.h"
#import "TimelineDAO.h"
#import "StatusUpdateDAO.h"
#import "FollowUserDAO.h"
#import "FollowTimelineDAO.h"

@interface ExempleViewController ()

@property (nonatomic, strong) TimelineDAO *timelineDAO;
@property (nonatomic, strong) StatusUpdateDAO *statusUpdateDAO;
@property (nonatomic, strong) FollowUserDAO *followUserDAO;
@property (nonatomic, strong) FollowTimelineDAO *followTimelineDAO;

@end

@implementation ExempleViewController

@synthesize timelineDAO;
@synthesize statusUpdateDAO;
@synthesize followUserDAO;
@synthesize followTimelineDAO;


// Initializes timelineDAO
- (TimelineDAO *)timelineDAO {
    if (!timelineDAO) {
        timelineDAO = [[TimelineDAO alloc] init];
    }
    
    return timelineDAO;
}

// Initializes statusUpdateDAO
- (StatusUpdateDAO *)statusUpdateDAO {
    if (!statusUpdateDAO) {
        statusUpdateDAO = [[StatusUpdateDAO alloc] init];
    }
    
    return statusUpdateDAO;
}

// Initializes followUsersDAO
- (FollowUserDAO *)followUserDAO {
    if (!followUserDAO) {
        followUserDAO = [[FollowUserDAO alloc] init];
    }
    
    return followUserDAO;
}

// Initializes followTimelineDAO
- (FollowTimelineDAO *)followTimelineDAO {
    if (!followTimelineDAO) {
        followTimelineDAO = [[FollowTimelineDAO alloc] init];
    }
    
    return followTimelineDAO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    // I'm adding code now.
    // I'm adding more code now.
    // I'm adding more and more code now.
}

// A test button that call a DAO (Data Acess Object) class method
- (IBAction)downloadUserButton:(id)sender {
   
    [SVProgressHUD showWithStatus:@"Loading users"];
    [UserDAO downloadUser:^(CAUsersContainer *users, NSError *error) {
       
        if (error) {
            [SVProgressHUD showErrorWithStatus:error.localizedDescription];
        }
        else {
            [SVProgressHUD dismiss];
            NSLog(@"%@",users);
        }
        
    }];

}

// Another test button that call a DAO (Data Acess Object) class method
- (IBAction)downloadTimelineButton:(id)sender {
    NSDictionary *timelines = [self.timelineDAO downloadTimeline];
    NSLog(@"%@", timelines);
}

// Another test button that call a DAO (Data Acess Object) class method
- (IBAction)downloadStatusupdatesButton:(id)sender {
    NSDictionary *statusUpdate = [self.statusUpdateDAO downloadStatusUpdate];
    NSLog(@"%@", statusUpdate);
}

// Another test button that call a DAO (Data Acess Object) class method
- (IBAction)downloadFollowUsersButton:(id)sender {
    NSDictionary *followUsers = [self.followUserDAO downloadFollowUser];
    NSLog(@"%@", followUsers);
}

// Another test button that call a DAO (Data Acess Object) class method
- (IBAction)downloadFollowTimelineButton:(id)sender {
    NSDictionary *followTimeline = [self.followTimelineDAO downloadFollowTimeline];
    
    NSLog(@"%@", followTimeline);
}
@end
