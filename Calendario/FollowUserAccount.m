//
//  FollowUserAccount.m
//  Calendario
//
//  Created by Daniel Sadjadian on 16/06/2015.
//
//

#import "FollowUserAccount.h"
#import "KeychainItemWrapper.h"

@implementation FollowUserAccount {
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

-(NSArray *)followUserAccount:(int)userFollow {
    
    // Response info array stores the success
    // number & if failed, stores the reason why.
    NSArray *responseInfo;
    
    // Get the user ID - we need to pass this
    // to the follow user PHP file.
    int userIDNumber = [self getUserID];
    
    if (userIDNumber == -1) {
        responseInfo = @[@1, @"User ID number could not be found"];
    }
    
    else {
        
        // Create the URL to the follow user PHP file.
        NSString *urlFormatted = [NSString stringWithFormat:@"%@followuser/%d/%d", webServiceAddress, userFollow, userIDNumber];
        
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
            NSString *status = [jsonData valueForKey:@"status"];
            NSString *msg = jsonData[@"msg"];
            
            if (([status isEqualToString:@"true"]) && ([msg isEqual:@"sucess"] || [msg isEqual:@"success"])) {
                
                // The follow user operation has worked correctly.
                responseInfo = @[@0, @"User follow request successful."];
            }
            
            else {
                responseInfo = @[@1, msg];
            }
        }
        
        else {
            
            // An error has occured thus we cannot be
            // sure that the user account has been followed.
            responseInfo = @[@1, @"No data has been returned from the follow user PHP file."];
        }
    }
    
    return responseInfo;
}

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

@end
