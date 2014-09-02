//
//  ViewController.m
//  Calendario
//
//  Created by Harith Bakri on 6/12/14.
//
//

#import "ViewController.h"
#import "UserDAO.h"
#import "TimelineDAO.h"

@interface ViewController ()

@property (nonatomic, strong) UserDAO *userDAO;
@property (nonatomic, strong) TimelineDAO *timelineDAO;

@end

@implementation ViewController

@synthesize userDAO;
@synthesize timelineDAO;

// Initialises userDAO
- (UserDAO *)userDAO
{
    if (userDAO == nil) {
        userDAO = [[UserDAO alloc] init];
    }
    
    return userDAO;
}

// Initialises timelineDAO
- (TimelineDAO *)timelineDAO {
    if (timelineDAO == nil) {
        timelineDAO = [[TimelineDAO alloc] init];
    }
    
    return timelineDAO;
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
    NSDictionary *users = [self.userDAO downloadUser];
    NSLog(@"%@", users);
}

- (IBAction)downloadTimelineButton:(id)sender {
    NSDictionary *timelines = [self.timelineDAO downloadTimeline];
    NSLog(@"%@", timelines);
}

@end
