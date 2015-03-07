//
//  RegisterPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import "RegisterPage.h"
#import "KeychainItemWrapper.h"

@interface RegisterPage ()

@end

@implementation RegisterPage

-(void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create instance of NSUSerDefaults.
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self.doneButton.layer setCornerRadius:5.0]; 
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPasswordsMatch {
    
    // Check that the two apssword fields are identical.
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        
        NSLog(@"passwords match!");
        [self registerNewUser];
    }
    
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
}

-(IBAction)backgroundTab:(id)sender {
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)doneButton:(id)sender {
    
    // Check if all text fields are completed.
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""])
    {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

-(void)registerNewUser {
    
    // Before adding the password to the URL, we need
    // to encrypt it for obvious reasons. We will use
    // Apple's keychain API to encrypt the password.
    
    // This is a work in progress. I have sent all Calendario
    // team members a message about this because we really
    // do need server side encryption to get this working.
    // For the time being the app can store the information
    // securely in the keychain (which we need anyway) and
    // currently passes the non-encrypted versions to the
    // register PHP files (this is a TEMPORARY solution.
    
    // Now that the username/password have been encrypted,
    // lets store them securly in the iOS Keychain.
    KeychainItemWrapper *keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    [keychain setObject:_usernameField.text forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:_passwordField.text forKey:(__bridge id)kSecValueData];
    
    // Create the URL to the User Register PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@register/%@/%@/%@/", webServiceAddress, _usernameField.text, _passwordField.text, _emailField.text];
    
    // Ensure the string is in UTF8 format.
    NSString *urlTextEscaped = [urlFormatted stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Create the request and add the URL.
    NSURLRequest *registerRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlTextEscaped]];
    
    // Store the JSON responce and check for
    // any response errors before parsing.
    NSURLResponse *response = nil;
    NSError *requestError = nil;
    NSData *urlData = [NSURLConnection sendSynchronousRequest:registerRequest returningResponse:&response error:&requestError];
    
    if ((requestError == nil) && (urlData != nil)) {
        
        NSString *responseData = [[NSString alloc] initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        NSLog(@"\n\n JSON DATA RETURNED: %@\n\n", jsonData);
        
        // The server will send back a success integer,
        // parse it and decide what to do next.
        NSInteger success = 0;
        success = [jsonData[@"success"] integerValue];
        
        if (success == 1) {
            // The registration has been completed,
            // go on to saving the user details locally.
            [self saveUserData];
            
        } else {
            
            // There has been an error so delete the username
            // and password from the keychain.
            [keychain resetKeychainItem];
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error_msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
        }
    }
    
    else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", requestError] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
}

-(void)saveUserData {
    
    // Alert the user of the account creation success.
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}

@end
