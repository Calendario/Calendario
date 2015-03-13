//
//  LoginPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/25/14.
//
//

#import "LoginPage.h"
#import "FacebookLogin.h"
#import "GooglePlus.h"
#import "KeychainItemWrapper.h"

@interface LoginPage () {
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

@end

@implementation LoginPage

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)loginUserV2 {
    
    // Get the current date/time string.
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *resultDate = [dateFormatter stringFromDate: currentTime];
    
    // Create the URL to the User Register PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@singin/%@/%@/%@/", webServiceAddress, _txtUsername.text, _txtPassword.text, resultDate];
    
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
        
        // Get the JSON data and parse it.
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        // Check the responce for a success.
        NSString *successString = [jsonData objectForKey:@"msg"];
        
        if ([successString isEqualToString:@"sucess"] || [successString isEqualToString:@"success"]) {
            
            // The login has been completed,
            // go on to alert and then home view.
            [self alertStatus:@"Login has been successful." :@"Success" :1];
        }
        
        else {
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            [self alertStatus:error_msg :@"Error" :0];
        }
    }
    
    else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        [self alertStatus:[NSString stringWithFormat:@"%@", requestError] :@"Error" :0];
    }
}

-(IBAction)signinClicked:(id)sender {
    [self loginUserV2];
}

-(void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    
    [alertView show];
}

// Keyboard Dismiss

-(IBAction)backgroundTab:(id)sender {
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

// UIAlertView delegate methods.

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if ((alertView.tag == 1) && (buttonIndex == 0)) {
        
        // Save the login data (username and password).
        // Securely save username and password to the Keychain.
        keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
        [keychain setObject:_txtUsername.text forKey:(__bridge id)kSecAttrAccount];
        [keychain setObject:_txtPassword.text forKey:(__bridge id)kSecValueData];
        
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
