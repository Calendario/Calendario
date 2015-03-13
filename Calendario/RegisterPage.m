//
//  RegisterPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import "RegisterPage.h"
#import "KeychainItemWrapper.h"

@interface RegisterPage () {
    
    // Alert which appears after registration.
    UIAlertView *successAlert;
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

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
    
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        // The server will send back a success integer,
        // parse it and decide what to do next.
        NSString *success = jsonData[@"msg"];
        
        if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
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
    
    // Securely save username and password to the Keychain.
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    [keychain setObject:_usernameField.text forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:_passwordField.text forKey:(__bridge id)kSecValueData];
    
    // Alert the user of the account creation success.
    successAlert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"You have been registered. Press OK to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [successAlert show];
}

// UIAlertView delegate methods.

-(void)alertView:(UIAlertView *)successAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        // Now present the home view.
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *myController = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        [self presentViewController:myController animated:YES completion:nil];
        
        // The below code crashes for some reason. It says that there is no
        // segue with the identifier "HomeViewController" - even though there
        // is. I know this because I set it in Interface builder (Dan).
        //[self performSegueWithIdentifier:@"HomeViewController" sender:self];
    }
}

@end
