//
//  RegisterViewController.m
//  Calendario
//
//  Created by Harith Bakri on 8/7/14.
//
//

#import "RegisterViewController.h"

@implementation RegisterViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    //Do any addtional setup after loading the view, typicall from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"Registered"]) {
        NSLog(@"No User Registered");
        _ReenterpasswordField.hidden = YES;
        _DoneButton.hidden = YES;
    }
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //Dipose of any resources
}




- (IBAction)Done:(id)sender {
    if ([_UserNameField.text isEqualToString:@""] || [_PasswordField.text isEqualToString:@""] ||
        [_ReenterpasswordField.text isEqualToString:@""] || [_EmailaddressField.text isEqualToString:@""]) {
        
    
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [error show];
        
    }
    else {
        [self checkPasswordsMatch];
    }
}


- (void) checkPasswordsMatch {
    if ([_PasswordField.text isEqualToString:_ReenterpasswordField.text]) {
        NSLog(@"Passwords Match!");
    
    }
    else {
        NSLog(@"Passwords Don't Match");
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your Entered Passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
       
        [error show];
    }
}

- (void) registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_UserNameField forKey:@"Username"];
    [defaults setObject:_EmailaddressField forKey:@"Email Address"];
    [defaults setObject:_PasswordField forKey:@"Password"];
    [defaults setBool:YES forKey:@"Registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have a registered a new new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}


- (IBAction)DoneButton:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([_UserNameField.text isEqualToString:[defaults objectForKey:@"Username"]] && [_PasswordField.text isEqualToString:[defaults objectForKey:@"Password"]]) {
        _UserNameField.text = nil;
        _PasswordField.text = nil;
        
        NSLog(@"Login Credentials Accepted");
        [self performSegueWithIdentifier:@"login" sender:self];
    }
    else {
        NSLog(@"Login Credentials Incorrect");
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Your Username And Password Does Not Match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [error show];
    }
}
@end
