//
//  StatusUpdateDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import "StatusUpdateDAO.h"

@interface StatusUpdateDAO ()

@property (nonatomic, strong) NSDictionary *statusUpdate;

@end

@implementation StatusUpdateDAO

- (NSDictionary *)downloadStatusUpdate
{
    // Download the json file
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@StatusUpdate.php", webServiceAddress]];
    
    // Create the request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
    
    // Create the operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.statusUpdate = (NSDictionary *)responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alertView show];
    }];
    
    [operation start];

    return self.statusUpdate;
}

-(void)uploadStatusUpdate {
    
}
@end
