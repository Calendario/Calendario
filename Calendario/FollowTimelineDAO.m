//
//  FollowTimelineDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import "FollowTimelineDAO.h"

@interface FollowTimelineDAO ()

@property (nonatomic, strong) NSDictionary *followTimeline;

@end

@implementation FollowTimelineDAO

- (NSDictionary *)downloadFollowTimeline
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@FollowTimeline.php", webServiceAddress]];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.followTimeline = (NSDictionary *)responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [operation start];
    
    return self.followTimeline;
}

- (void)uploadFollowTimeline
{
    
}

@end
