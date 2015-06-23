//
//  ReportBugView.m
//  Calendario
//
//  Created by Daniel Sadjadian on 19/02/2015.
//
//

#import "ReportBugView.h"
#import "KeychainItemWrapper.h"

@interface ReportBugView () {
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

@end

@implementation ReportBugView

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Report bug method

-(int)getUserID {
    
    // User ID number.
    int userID;
    
    // Get the user ID - we need to pass this
    // to the user profile PHP file.
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    NSString *username = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    // Create the URL to the User profile PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@profile/%@", webServiceAddress, username];
    
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
            
            // The profile data has been loaded correctly,
            // lets parse the data & get the ID number.
            userID = [[[[jsonData objectForKey:@"userprofile"] objectForKey:@"User"] valueForKey:@"id"] intValue];
        }
        
        else {
            
            // Error user ID not found.
            return -1;
        }
    }
    
    else {
        
        // Error user ID not found.
        return -1;
    }
    
    return userID;
}

-(IBAction)sendBugReport:(id)sender {
    
    // Submit the bug report to the server.
    
    if ((_bugTitle.text == nil) || (_bugDesc.text == nil) || ([_bugTitle.text isEqualToString:@""]) || ([_bugDesc.text isEqualToString:@""])) {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You cannot send an empty bug report. Please fill in some details and then press send." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
    
    else {
        
        // Setup the register POST request.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@newbug", webServiceAddress]]];
        [request setHTTPMethod:@"POST"];
        
        // 1. Set the header - Content-Type.
        NSDictionary *the_header = @{@"Content-type" : @"application/x-www-form-urlencoded"};
        [request setAllHTTPHeaderFields:the_header];
        
        // 2. Get the user ID number.
        int userIDNumber = [self getUserID];
        
        if (userIDNumber == -1) {
            
            // The user ID number has not been obtained
            // thus the bug report cannot be sent because
            // we don't know the ID number of the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The bug report could not be sent because your user ID number is not known." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
        }
        
        else {
            
            // 3. Set the paramters & metadata for the request (eg: title).
            NSString *postString = [NSString stringWithFormat:@"user=%d&title=%@&msg=%@", userIDNumber, _bugTitle.text, _bugDesc.text];
            
            // 4. Convert metadata into form format and submit.
            [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
            
            // 5. Get the response back from the server and parse it.
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if ((returnedData != nil) && (error == nil)) {
                
                NSError *jsonError = nil;
                NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:returnedData options:NSJSONReadingMutableContainers error:&jsonError];
                
                // The server will send back a success integer,
                // parse it and decide what to do next.
                NSString *success = responseData[@"msg"];
                
                if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
                    
                    // The registration has been completed,
                    // go on to saving the user details locally.
                    
                    UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"Bug report sent" message:@"The bug report has been submitted." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    
                    [successAlert show];
                }
                
                else {
                    
                    // Parse the error message passed back from the server.
                    NSString *error_msg = (NSString *)responseData[@"error_message"];
                    
                    // Display the error message to the user.
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error_msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                    
                    [errorAlert show];
                }
            }
            
            else {
                
                // There has been an issue with the connection
                // to the server - probably internet connection.
                UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                
                [errorAlert show];
            }
        }
    }
}

#pragma mark - Other methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [_bugDesc resignFirstResponder];
    }
    
    return YES;
}

@end
