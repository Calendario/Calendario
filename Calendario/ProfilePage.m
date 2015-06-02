//
//  ProfilePage.m
//  Calendario
//
//  Created by Daniel Sadjadian on 18/05/2015.
//
//

#import "ProfilePage.h"
#import "KeychainItemWrapper.h"

@interface ProfilePage () {
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

@end

@implementation ProfilePage

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Load the profile information.
    [self loadProfileData];
}

/// DATA LOAD METHODS ///

-(void)loadProfileData {
    
    // Get the user ID - we need to pass this
    // to the user profile PHP file.
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    NSString *userID = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    
    // Create the URL to the User profile PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@profile/%@", webServiceAddress, userID];
    
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
            // lets parse the data & present it to the user.
            
            NSArray *profileInfo = [[jsonData objectForKey:@"userprofile"] objectForKey:@"User"];
            
            // Set the appropriate labels.
            [_fullNameLabel setTitle:[profileInfo valueForKey:@"fullname"] forState:UIControlStateNormal];
            //[_userWebsite setTitle:[profileInfo valueForKey:@"website"] forState:UIControlStateNormal];
            //_descriptionLabel.text = [profileInfo valueForKey:@"description"];
            
            /*
             "id": "11",
             "username": "chavesdev",
             "fullname": null,
             "email": "epxter@gmail.com",
             "joined": "2015-02-23 00:47:23"
             */
        }
        
        else {
            
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

/// OTHER METHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
