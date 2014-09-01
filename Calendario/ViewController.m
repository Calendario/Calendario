//
//  ViewController.m
//  Calendario
//
//  Created by Harith Bakri on 6/12/14.
//
//

#import "ViewController.h"
#import "UserDAO.h"

@interface ViewController ()
@property (nonatomic, strong) UserDAO *userDAO;
@end

@implementation ViewController

@synthesize userDAO;

- (UserDAO *)userDAO
{
    if (userDAO == nil) {
        userDAO = [[UserDAO alloc] init];
    }
    
    return userDAO;
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
    [self.userDAO downloadUser];
}
@end
