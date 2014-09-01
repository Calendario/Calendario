//
//  UserDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

#import "UserDAO.h"

// static NSString *const BASEURL = @"http://localhost:8888/calendario/";

@implementation UserDAO

- (NSDictionary *)downloadUser
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:@"http://localhost:8888/calendario/User.php"];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.user = (NSDictionary *)responseObject;
        NSLog(@"self.user: %@", self.user);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [operation start];
    
    return  self.user;
}

- (void)uploadUser
{
    // AFNetworking code to upload goes here
}

@end
