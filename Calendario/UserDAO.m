//
//  UserDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

#import "UserDAO.h"

@interface UserDAO ()

@property (nonatomic, strong) NSDictionary *user;

@end

@implementation UserDAO

- (NSDictionary *)downloadUser
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/User.php", webServiceAddress]];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.user = (NSDictionary *)responseObject;
        
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
