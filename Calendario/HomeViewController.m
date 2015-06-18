//
//  HomeViewController.m
//  Calendario
//
//  Created by Harith Bakri on 11/25/14.
//
//

#import "HomeViewController.h"
#import "customTabBarViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize userData;

-(IBAction)open_profile:(id)sender {
    
    // Testing.... TEMPORARY ONLY...
    
    // ProfilePage
    // ReportBugViewController
    // SearchView
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"SearchView"];
    [self presentViewController:myController animated:YES completion:nil];
    
    // Testing.... TEMPORARY ONLY...
}

-(IBAction)followUserTEST:(id)sender {
    [self followAUser:34];
}

-(void)followAUser:(int)userID {
    
    self.userData = [[FollowUserAccount alloc] init];
    NSArray *responseData = [self.userData followUserAccount:userID];
    
    // User follow response info.
    // Returned in the form of an array like so:
    // [@ 1 or 0, @"string response message"].
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"%@", responseData[1]] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self performSegueWithIdentifier:@"login_success" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//test harith branch
//test harith branch 2
@end
