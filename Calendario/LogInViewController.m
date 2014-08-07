//
//  LogInViewController.m
//  Calendario
//
//  Created by Harith Bakri on 8/8/14.
//
//

#import "LogInViewController.h"

@interface LogInViewController ()

@end

@implementation LogInViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)SignInButton:(id)sender {
    
    [PFUser loginWithUsernameInBackground:_UsernameField.text password:_PasswordField.text block:(PFUser *user , NSError *error) {
        If (!error) {
            NSLog(@"Login User!");
            _PasswordField.text = nil;
            _UsernameField.text = nil;
            _PasswordField.text = nil;
            
            [self performSegueWithIdentifier:@"Login" sender:self];
        }
      
        
    }
     if(error) {
         UIAlertView *alert = [[UIAlertView alloc] initWithTittle:@"Oops!" message:@"Sorry We Had Problem Logging You In" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         
         [alert show];
     }
     
}
@end
