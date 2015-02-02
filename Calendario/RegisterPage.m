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
    
    // Create instance of NSUSerDefaults.
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self.doneButton.layer setCornerRadius:5.0]; 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkPasswordsMatch
{
    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text])
    {
        NSLog(@"passwords match!");
        [self registerNewUser];
    }
    else
    {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
    
}

- (IBAction)backgroundTab:(id)sender
{
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneButton:(id)sender
{
    //check if all text fields are completed
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""])
    {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
    else
    {
        [self checkPasswordsMatch];
    }
}

- (void)registerNewUser
{
    
    // Register a new account with the Calendario server.
    NSString *URL = [NSString stringWithFormat:@"%@v1/require/UserReq.php", webServiceAddress];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // Pass the email, username and password in to the request.
    NSString *paramPass = [NSString stringWithFormat:@"email=%@&user=%@&pass=%@", _emailField.text, _usernameField.text, _passwordField.text];
    
    [manager POST:URL parameters:paramPass success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // Request has worked, go on to saveing
        // the user data locally.
        [self saveUserData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // The request has failed, alert the user,
        // and do not save the user data locally.
        // Parse the responce JSON from the server.
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&error];
        
        NSLog(@"\n\n\n\n Server Responce: %@ \n\n\n\n", result);
        
        UIAlertView *reqError = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"error" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
        [reqError show];
    }];
}


- (void)saveUserData
{
    
    // Save the username/password locally.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // write the username and password and set BOOL value in NSUserDefaults.
    [defaults setObject:_usernameField.text forKey:@"username"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}


@end


