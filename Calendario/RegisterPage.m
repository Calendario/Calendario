//
//  RegisterPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import "RegisterPage.h"

@interface RegisterPage ()

@end

@implementation RegisterPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //create instance of NSUSerDefaults
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkPasswordsMatch {
    
    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"passwords match!");
        [self _registerNewUser];
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    
}

- (IBAction)backgroundTab:(id)sender {
    
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneButton:(id)sender {
    //check if all text fields are completed
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }

        
        - (void) registerNewUser {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            //write the username and password and set BOOL value in NSUserDefaults
            [defaults setObject:_usernameField.text forKey:@"username"];
            [defaults setObject:_passwordField.text forKey:@"password"];
            [defaults setBool:YES forKey:@"registered"];
            
            [defaults synchronize];
            
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [success show];
            
            [self performSegueWithIdentifier:@"login" sender:self];
        }
        
        @end

