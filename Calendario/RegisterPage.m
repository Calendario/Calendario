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
    // Create the URL to the User Register PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@v1/require/UserReq.php", webServiceAddress];
    NSURL *URL = [NSURL URLWithString:urlFormatted];
    
    // Add the email, username and password to the POST request.
    NSString *paramPass = [NSString stringWithFormat:@"json_option=register&email=%@&user=%@&password=%@", _emailField.text, _usernameField.text, _passwordField.text];
    
    // Format the data for the POST request.
    NSData *postData = [paramPass dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    // Create the POST request.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:URL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    // Server responce - Register PHP file.
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    // Check if the responce is between 200 - 299.
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"\n\n JSON DATA RETURNED: %@\n\n", jsonData);
        
        // The server will send back a success integer,
        // parse it and decide what to do next.
        NSInteger success = 0;
        success = [jsonData[@"success"] integerValue];
        
        if (success == 1)
        {
            // The registration has been completed,
            // go on to saving the user details locally.
            [self saveUserData];
            
        } else {
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error_msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
        }
        
    } else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Connection Failed." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
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


