//
//  ProfilePage.m
//  Calendario
//
//  Created by Daniel Sadjadian on 18/05/2015.
//
//

#import "ProfilePage.h"
#import "KeychainItemWrapper.h"

@interface ProfilePage () {
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
    
    // User ID/Password (for edit page).
    NSString *userIDNum;
    NSString *userPassword;
    
    // Reload data check.
    BOOL reloadCheck;
}

@end

@implementation ProfilePage

/// BUTTONS ///

-(IBAction)editUserProfile:(id)sender {
    
    if (userIDNum != nil) {

        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        EditProfile *editPage = [storyboard instantiateViewControllerWithIdentifier:@"EditMyProfile"];
        [editPage setPassInID:userIDNum];
        [editPage setPassInPass:userPassword];
        editPage.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:editPage animated:YES completion:nil];
    }
    
    else {
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No user ID number - cannot open user edit page." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
}

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    reloadCheck = NO;
    [self loadProfileData];
}

/// VIEW DID APPEAR ///

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (reloadCheck == YES) {
        
        // Load the profile information.
        [self loadProfileData];
    }
}

/// DATA LOAD METHODS ///

-(void)loadProfileData {
    
    // Get the user ID - we need to pass this
    // to the user profile PHP file.
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    NSString *userID = [keychain objectForKey:(__bridge id)(kSecAttrAccount)];
    userPassword = [keychain objectForKey:(__bridge id)(kSecValueData)];
    
    // Create the URL to the User profile PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@profile/%@", webServiceAddress, userID];
    
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
            NSArray *otherInfo = [jsonData objectForKey:@"userprofile"];
            
            // Set the user ID number (for user edit).
            userIDNum = [profileInfo valueForKey:@"id"];
            
            // Data parsed array.
            NSMutableArray *parsedData = [[NSMutableArray alloc] init];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"fullname"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"website"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"description"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [otherInfo valueForKey:@"followers"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [otherInfo valueForKey:@"following"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [otherInfo valueForKey:@"posts"]]];
            
            // No value set label array.
            NSArray *noData = @[@"No name set.", @"No website set.", @"No description set.", @"0", @"0", @"0"];
            
            // Now set the labels/buttons accordingly.
            // Check for any nil/NULL/Blank values first.
            for (int loop = 0; loop < 6; loop++) {
                
                NSString *currentString = [parsedData objectAtIndex:loop];
                
                if ((currentString == nil) || (currentString == NULL) || ([currentString isEqualToString:@"<null>"]) || ([currentString isEqualToString:@""])) {
                    [parsedData replaceObjectAtIndex:loop withObject:[NSString stringWithFormat:@"%@", noData[loop]]];
                }
            }
    
            // Set the various labels.
            [_fullNameLabel setTitle:[NSString stringWithFormat:@"%@", parsedData[0]] forState:UIControlStateNormal];
            [_userWebsite setTitle:[NSString stringWithFormat:@"%@", parsedData[1]] forState:UIControlStateNormal];
            _descriptionLabel.text = [NSString stringWithFormat:@"%@", parsedData[2]];
            [_followerCountLabel setTitle:[NSString stringWithFormat:@"%@", parsedData[3]] forState:UIControlStateNormal];
            [_followingCountLabel setTitle:[NSString stringWithFormat:@"%@", parsedData[4]] forState:UIControlStateNormal];
            _postCountLabel.text = [NSString stringWithFormat:@"%@", parsedData[5]];
            
            // Set the posts loaded by label.
            _postsLoadedBy.text = [NSString stringWithFormat:@"Posts that uploaded by %@", parsedData[0]];
            
            // Download the user's profile image.
            UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"image"]]]]];
            
            if (profileImage != nil) {
                [_profilePicture setImage:profileImage];
            }
            
            // Check if the user is verified or not.
            int verified = [[profileInfo valueForKey:@"verified"] intValue];
            
            if (verified == 1) {
                [_verifiedRibbon setAlpha:1.0];
            }
            
            else {
                [_verifiedRibbon setAlpha:0.0];
            }
            
            // Allow the data to be reloaded when required.
            reloadCheck = YES;
        }
        
        else {
            
            // Allow the data to be reloaded when required.
            reloadCheck = YES;
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error_msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
        }
    }
    
    else {
        
        // Allow the data to be reloaded when required.
        reloadCheck = YES;
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", requestError] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
}

/// OTHER METHODS ///

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
