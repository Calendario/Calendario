//
//  FollowersView.m
//  Calendario
//
//  Created by Daniel Sadjadian on 20/07/2015.
//
//

#import "FollowersView.h"

@interface FollowersView () {
    
    NSArray *followerID;
    NSArray *followerName;
    NSArray *followerProfileImage;
    NSArray *followerVerified;
}

@end

@implementation FollowersView

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/// DATA LOAD METHODS ///

-(void)getSearchData:(int)userID {
    
    // Create the URL to the my followers PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@myfollowers/%d", webServiceAddress, userID];
    
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
            
            // The follower data has been loaded correctly,
            // lets parse the data & present it to the user.
            NSArray *followersInfo = [[jsonData objectForKey:@"followers"] valueForKey:@"Follow"];
            
            // Data parsed array.
            followerID = [followersInfo valueForKey:@"idfollower"];
            
            // Now we have to get the various user profile data
            // such as: username, profile picture and verified check.
            
            for (NSUInteger loop = 0; loop < [followerID count]; loop++) {
                
                
            }
            
            // Present the data in the tableview.
            [_followersList reloadData];
        }
        
        else if ([success isEqual:@"Nothing found"]) {
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No results have been found for your search." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
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

-(NSMutableArray *)loadProfileData:(int)userID {
    
    // Profile return data.
    NSMutableArray *parsedData = [[NSMutableArray alloc] init];
    
    // Create the URL to the User profile PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@profile/%d", webServiceAddress, userID];
    
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
            
            // Data parsed array.
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"username"]]];
            [parsedData addObject:[NSNumber numberWithInteger:[[profileInfo valueForKey:@"verified"] intValue]]];
        }
        
        else {
            
            // Error - no user data has been returned.
            // Also ensure that the array is empty before
            // adding the error message to it.
            parsedData = [[NSMutableArray alloc] init];
            [parsedData addObject:[NSString stringWithFormat:@"Error - no data"]];
        }
    }
    
    else {
        
        // Error - no user data has been returned.
        // Also ensure that the array is empty before
        // adding the error message to it.
        parsedData = [[NSMutableArray alloc] init];
        [parsedData addObject:[NSString stringWithFormat:@"Error - no data"]];
    }
    
    return parsedData;
}

/// TABLE VIEW METHODS ///

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [followerID count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowerCell *cell = (FollowerCell *)[_followersList dequeueReusableCellWithIdentifier:@"FollowerCell"];
    
    // Set the username.
    cell.username.text = [NSString stringWithFormat:@"%@", followerName[indexPath.row]];
    
    // Check if the user is verified or not.
    int verified = [followerVerified[indexPath.row] intValue];
    
    if (verified == 1) {
        [cell.verifiedRibbon setAlpha:1.0f];
    }
    
    // Set the user profile image.
    
    // Check if you are following the follower.
    
    return cell;
}

/// OTHER EMTHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
