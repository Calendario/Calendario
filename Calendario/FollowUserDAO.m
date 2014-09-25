//
//  FollowUserDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import "FollowUserDAO.h"

@interface FollowUserDAO ()

@property (nonatomic, strong) NSDictionary *followUser;

@end

@implementation FollowUserDAO

- (NSDictionary *)downloadFollowUser
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@FollowUser.php", webServiceAddress]];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.followUser = (NSDictionary *)responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [operation start];
    
    return self.followUser;
}

- (void)uploadFollowUser
{
    
}
@end
