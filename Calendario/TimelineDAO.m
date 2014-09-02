//
//  TimelineDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/1/14.
//
//

#import "TimelineDAO.h"

@interface TimelineDAO ()

@property (nonatomic, strong) NSDictionary *timeline;

@end

@implementation TimelineDAO

- (NSDictionary *)downloadTimeline;
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/User.php", webServiceAddress]];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.timeline = (NSDictionary *)responseObject;
        NSLog(@"self.user: %@", self.timeline);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [operation start];
    
    return  self.timeline;
}

- (void)uploadTimeline
{
    // AFNetworking code to upload goes here
}

@end
