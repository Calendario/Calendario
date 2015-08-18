//
//  SearchTableViewController.m
//  Calendario
//
//  Created by Daniel Sadjadian on 13/06/2015.
//
//

#import "SearchTableViewController.h"

@interface SearchTableViewController () {
    
    NSArray *parsedDataName;
    NSArray *parsedDataDesc;
    NSArray *parsedDataImage;
    NSArray *parshedHashtags;
}

@end

@implementation SearchTableViewController

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/// SEARCH BAR METHODS ///

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [self getSearchDataUsers:searchBar.text];
}

/// DATA METHODS ///

-(void)getSearchDataUsers:(NSString *)searchTerm {
    
    // Create the URL to the Search user PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@searchuser/%@", webServiceAddress, searchTerm];
    
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
            NSArray *profileInfo = [[jsonData objectForKey:@"list"] valueForKey:@"User"];
            
            // Data parsed array.
            parsedDataName = [profileInfo valueForKey:@"fullname"];
            parsedDataDesc = [profileInfo valueForKey:@"description"];
            parsedDataImage = [profileInfo valueForKey:@"image"];
            
            // Now search for the possible hashtags.
            [self getSearchDataHashtags:searchTerm];
        }
        
        else if ([success isEqual:@"Nothing found"]) {
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No users have been found for your search." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
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

-(void)getSearchDataHashtags:(NSString *)searchTerm {
    
    // Create the URL to the Search hashtags PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@hashtag/search/%@", webServiceAddress, searchTerm];
    
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
            
            // The hashtag data has been loaded correctly,
            // lets parse the data & present it to the user.
            parshedHashtags = [[[jsonData objectForKey:@"list"] valueForKey:@"Hashtag"] valueForKey:@"name"];
            
            // Present the data in the tableview.
            [_searchTable reloadData];
        }
        
        else if ([success isEqual:@"Nothing found"]) {
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No hashtags have been found for your search." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
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

/// TABLE VIEW METHODS ///

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSUInteger data_count;
    
    if (section == 0) {
        data_count = [parsedDataName count];
    }
    
    else if (section == 1) {
        data_count = [parshedHashtags count];
    }
    
    return data_count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SearchCell *cell = (SearchCell *)[_searchTable dequeueReusableCellWithIdentifier:@"SearchCell"];
    
    // Set the labels.
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", parsedDataName[indexPath.row]];
    cell.descLabel.text = [NSString stringWithFormat:@"%@", parsedDataDesc[indexPath.row]];
    
    // Set the profile image.
    
    return cell;
}

/// OTHER METHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
