//
//  SearchTableViewController.m
//  Calendario
//
//  Created by Daniel Sadjadian on 13/06/2015.
//
//

#import "SearchTableViewController.h"

@interface SearchTableViewController () {
    
    // User search data.
    NSArray *parsedUserName;
    NSArray *parsedUserDesc;
    NSArray *parsedUserImage;
    
    // Hashtag search data.
    NSArray *parshedHashtags;
    NSArray *parsedHashtagUserIDs;
    NSMutableArray *parsedHashtagUsers;
    NSMutableArray *parsedHashtagImages;
}

@end

@implementation SearchTableViewController

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Initialise the hashtag username
    // and user profile image arrays.
    parsedHashtagUsers = [[NSMutableArray alloc] init];
    parsedHashtagImages = [[NSMutableArray alloc] init];
}

/// SEARCH BAR METHODS ///

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self getSearchDataUsers:searchBar.text];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

/// DATA METHODS ///

-(void)getSearchDataUsers:(NSString *)searchTerm {
    
    // Create the URL to the Search user PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@searchuser/%@", webServiceAddress, searchTerm];
    
    // Ensure the string is in UTF8 format.
    NSString *urlTextEscaped = [urlFormatted stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Setup the network session.
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Run the network session.
    [[session dataTaskWithURL:[NSURL URLWithString:urlTextEscaped] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Convert the downloaded data to JSON format.
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
        // The server will send back a success integer,
        // parse it and decide what to do next.
        NSString *success = jsonData[@"msg"];
        
        if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
            
            // The profile data has been loaded correctly,
            // lets parse the data & present it to the user.
            NSArray *profileInfo = [[jsonData objectForKey:@"list"] valueForKey:@"User"];
            
            // Data parsed array.
            parsedUserName = [profileInfo valueForKey:@"fullname"];
            parsedUserDesc = [profileInfo valueForKey:@"description"];
            parsedUserImage = [profileInfo valueForKey:@"image"];
        }
        
        // Now search for the possible hashtags.
        [self getSearchDataHashtags:searchTerm];
        
    }] resume];
}

-(void)getSearchDataHashtags:(NSString *)searchTerm {
    
    // Create the URL to the Search user PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@hashtag/search/%@", webServiceAddress, searchTerm];
    
    // Ensure the string is in UTF8 format.
    NSString *urlTextEscaped = [urlFormatted stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // Setup the network session.
    NSURLSession *session = [NSURLSession sharedSession];
    
    // Run the network session.
    [[session dataTaskWithURL:[NSURL URLWithString:urlTextEscaped] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Convert the downloaded data to JSON format.
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        // Resign the keyboard.
        [self.searchBar resignFirstResponder];
        
        // The server will send back a success integer,
        // parse it and decide what to do next.
        NSString *success = jsonData[@"msg"];
        
        if ((error == nil) && (data != nil)) {
            
            if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
                
                // The hashtag data has been loaded correctly,
                // lets parse the data & present it to the user.
                parshedHashtags = [[[jsonData objectForKey:@"list"] valueForKey:@"Statusupdate"] valueForKey:@"descstatus"];
                parsedHashtagUserIDs = [[[jsonData objectForKey:@"list"] valueForKey:@"Statusupdate"] valueForKey:@"id"];
                
                // Now get the usernames and profile pictures
                // for each of the status updates.
                [self getHashtagUserImages];
            }
            
            else {
                
                // Check the data first and then
                // go onto to the table view loading.
                [self checkTableViewData];
            }
        }
        
        else {
            
            // Check the data first and then
            // go onto to the table view loading.
            [self checkTableViewData];
        }
    }] resume];
}

-(void)getHashtagUserImages {
    
    // Loop through the hashtag user ID array
    // and download the user image URL.
    
    for (NSUInteger loop = 0; loop < [parsedHashtagUserIDs count]; loop++) {
        
        // Create the URL to the User profile PHP file.
        NSString *urlFormatted = [NSString stringWithFormat:@"%@profile/%@", webServiceAddress, parsedHashtagUserIDs];
        
        // Ensure the string is in UTF8 format.
        NSString *urlTextEscaped = [urlFormatted stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        // Create the request and add the URL.
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlTextEscaped]];
        
        // Store the JSON responce and check for
        // any response errors before parsing.
        NSURLResponse *response = nil;
        NSError *requestError = nil;
        NSData *urlData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&requestError];
        
        if ((requestError == nil) && (urlData != nil)) {
            
            NSError *error = nil;
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
            
            // The server will send back a success integer,
            // parse it and decide what to do next.
            NSString *success = jsonData[@"msg"];
            
            if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
                
                // Load the username and profile image link.
                NSString *userName = [[[jsonData objectForKey:@"userprofile"] valueForKey:@"User"] valueForKey:@"fullname"];
                NSString *profileImage = [[[jsonData objectForKey:@"userprofile"] objectForKey:@"User"] valueForKey:@"image"];
                
                // Save the data in the parsed data array.
                [parsedHashtagUsers addObject:userName];
                [parsedHashtagImages addObject:profileImage];
            }
        }
    }
    
    // Check the data first and then
    // go onto to the table view loading.
    [self checkTableViewData];
}


-(void)checkTableViewData {
    
    // Before we load the table view, we need to firgure out if
    // any data has been returned and if it has not, then we need
    // to display the appropriate error message on screen.
    
    if (([parsedUserName count] > 0) || ([parshedHashtags count] > 0)) {
        
        // Either user data or hashtag data has been returned,
        // so we can just go onto the table view data loading.
        [self.searchTable reloadData];
    }
    
    else if (([parsedUserName count] == 0) && ([parshedHashtags count] == 0)) {
     
        // Setup the error alert.
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"No users or hashtags were found for your search term." preferredStyle:UIAlertControllerStyleAlert];
        
        // Setup the dismiss action.
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
        
        // Add the action button to the alert.
        [alert addAction:cancel];
        
        // Display the error alert.
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/// TABLE VIEW METHODS ///

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger data_count;
    
    if (section == 0) {
        data_count = [parsedUserName count];
    }
    
    else if (section == 1) {
        data_count = [parshedHashtags count];
    }
    
    return data_count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup the search cell.
    SearchCell *cell = (SearchCell *)[_searchTable dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    // Get the appropriate prfole image.
    __block NSString *imageName = [NSString stringWithFormat:@"default_profile_pic.png"];
    BOOL onlineImage = NO;
    
    // Show and set the appropriate labels depending on
    // whether a user cell is being presented or a hastag cell.
    
    if (indexPath.section == 0) {
        
        // Set the username and profile description text.
        cell.titleLabel.text = [NSString stringWithFormat:@"%@", parsedUserName[indexPath.row]];
        cell.descLabel.text = [NSString stringWithFormat:@"%@", parsedUserDesc[indexPath.row]];
        
        // Hide the status message label.
        [cell.statusMessage setAlpha:0.0];
        
        // Set the profile image URL link.
        
        if ((indexPath.row < [parsedUserImage count]) && (parsedUserImage[indexPath.row] != nil)) {
            
            // Set the image URL and set the check to YES.
            imageName = [NSString stringWithFormat:@"%@", parsedUserImage[indexPath.row]];
            onlineImage = YES;
        }
    }
    
    else if (indexPath.section == 1) {
        
        // Set the username and the status post text.
        cell.titleLabel.text = [NSString stringWithFormat:@""];
        cell.statusMessage.text = [NSString stringWithFormat:@"%@", parshedHashtags[indexPath.row]];
        
        // Hide the description label.
        [cell.descLabel setAlpha:0.0];
        
        // Set the profile image URL link.
        
        if ((indexPath.row < [parsedHashtagImages count]) && (parsedHashtagImages[indexPath.row] != nil)) {
            
            // Set the image URL and set the check to YES.
            imageName = [NSString stringWithFormat:@"%@", parsedHashtagImages[indexPath.row]];
            onlineImage = YES;
        }
    }
    
    // Set the profile picture image.

    if (onlineImage == YES) {
        
        // Setup the asynchronous thread.
        char const *check = [[NSString stringWithFormat:@"Photo Load"] UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(check, 0);
        
        // Load the image in the background thread.
        dispatch_async(queue, ^{
            
            // Check for a valid URL scheme.
            NSURLComponents *url_check = [[NSURLComponents alloc] initWithString:imageName];
            
            if ([url_check scheme] == nil) {
                imageName = [NSString stringWithFormat:@"http://%@", imageName];
            }
            
            // Download the image in a NSData object.
            NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageName]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (image_data != nil) {
                    
                    // Set the image view on the main thread.
                    [cell.picture setImage:[UIImage imageWithData:image_data]];
                }
                
                else {
                    
                    // Sometimes no image data is returned for a
                    // user profile image therefore set the default
                    // local PNG image as the profile image.
                    [cell.picture setImage:[UIImage imageNamed:imageName]];
                }
            });
        });
    }
    
    else {
        [cell.picture setImage:[UIImage imageNamed:imageName]];
    }
    
    return cell;
}

/// OTHER METHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
