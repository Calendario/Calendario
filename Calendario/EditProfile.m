//
//  EditProfile.m
//  Calendario
//
//  Created by Daniel Sadjadian on 26/08/2015.
//
//

#import "EditProfile.h"
#import "KeychainItemWrapper.h"
#import <QuartzCore/QuartzCore.h>

@interface EditProfile () {
    
    // Profile picture.
    UIImage *chosenImage;
    
    // Image type.
    // 1 = library, 2 = camera photo.
    int imageType;
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
}

@end

@implementation EditProfile
@synthesize passInID;
@synthesize passInPass;

/// BUTTONS ///

-(IBAction)saveUserEdits:(id)sender {
    
    // Check that none of the fields are empty
    // before submitting the user edited data.
    
    if (([_userFullName.text isEqualToString:@""]) || ([_userDescription.text isEqualToString:@""]) || ([_userEmailAddress.text isEqualToString:@""]) || ([_userWebsiteURL.text isEqualToString:@""]) || ([_userPassword.text isEqualToString:@""])) {
        
        [self displayErrorAlert:@"Please ensure that no fields are empty before saving."];
    }
    
    else {
        
        // Setup the register POST request.
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@user/edit", webServiceAddress]]];
        [request setHTTPMethod:@"POST"];
        
        // 1. Set the header - Content-Type.
        NSDictionary *the_header = @{@"Content-type" : @"application/x-www-form-urlencoded"};
        [request setAllHTTPHeaderFields:the_header];
        
        // Get the UIImage (profile picture) and convert
        // it to a data string which can be passed to the
        // server for processing.
        NSData *imageData = UIImagePNGRepresentation(chosenImage);
        NSString *imageString = [[NSString alloc] initWithBytes:[imageData bytes] length:[imageData length] encoding:NSUTF8StringEncoding];
        
        // 2. Set the paramters & metadata for the request (eg: title).
        NSString *postString = [NSString stringWithFormat:@"id=%@&fullname=%@&website=%@&description=%@&password=%@&image=%@", passInID, _userFullName.text, _userWebsiteURL.text, _userDescription.text, _userPassword.text, imageString];
        
        // 3. Convert metadata into form format and submit.
        [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 4. Get the response back from the server and parse it.
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        NSData *returnedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if ((returnedData != nil) && (error == nil)) {
            
            NSError *jsonError = nil;
            NSDictionary *responseData = [NSJSONSerialization JSONObjectWithData:returnedData options:NSJSONReadingMutableContainers error:&jsonError];
            
            // The server will send back a success integer,
            // parse it and decide what to do next.
            NSString *success = responseData[@"msg"];
            
            if ([success isEqual:@"sucess"] || [success isEqual:@"success"]) {
                
                // Save the new password locally as well.
                keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
                [keychain setObject:_userPassword.text forKey:(__bridge id)kSecValueData];
                
                // Now close the edit view.
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            else {
                
                // Parse the error message passed back from the server.
                NSString *error_msg = (NSString *)responseData[@"error_message"];
                
                // Display the error message to the user.
                [self displayErrorAlert:[NSString stringWithFormat:@"%@", error_msg]];
            }
        }
        
        else {
            
            // There has been an issue with the connection
            // to the server - probably internet connection.
            [self displayErrorAlert:[NSString stringWithFormat:@"%@", error]];
        }
    }
}

-(IBAction)editUserImage:(id)sender {
    
    // Setup the image picker.
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    // Prepare the choice alert.
    UIAlertController *choiceAlert = [UIAlertController alertControllerWithTitle:@"Profile Picture" message:@"Would you like to take a picture or use an existing image?" preferredStyle:UIAlertControllerStyleAlert];

    // Create the alert actions.
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Take a new image.
        imageType = 1;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            if ([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront]) {
                picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
        else {
            
            // Display the camera error alert.
            [self displayErrorAlert:@"You can not take a photo because your device does not have a camera."];
        }
    }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Photo library.
        imageType = 2;
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:NULL];
        }
        
        else {
    
            // Display the photo library error alert.
            [self displayErrorAlert:@"There was an error accessing your photo library. Make sure you have granted Calendario access to your photos."];
        }
    }];
    
    // Add the action and present the alert.
    [choiceAlert addAction:camera];
    [choiceAlert addAction:photos];
    [choiceAlert addAction:dismiss];
    [self presentViewController:choiceAlert animated:YES completion:nil];
}

-(IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the scroll view properties.
    [_profileScroll setScrollEnabled:YES];
    [_profileScroll setContentSize:CGSizeMake(self.view.bounds.size.width, 600)];
    
    // Round the edges of the picture button.
    _userProfileImage.layer.cornerRadius = 36;
    _userProfileImage.layer.masksToBounds = YES;
    
    // By default no changes have been made (yet..).
    _saveButton.userInteractionEnabled = NO;
    _saveButton.alpha = 0.5;
    
    // Load in the user data.
    [self loadUserData];
}

/// DATA LOAD METHODS ///

-(void)loadUserData {
    
    // Create the URL to the edit (load) profile PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@user/edit/%@", webServiceAddress, passInID];
    
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
            NSArray *profileInfo = [[jsonData objectForKey:@"user"] objectForKey:@"User"];
            
            // Data parsed array.
            NSMutableArray *parsedData = [[NSMutableArray alloc] init];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"fullname"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"website"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"description"]]];
            [parsedData addObject:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"email"]]];
            
            // No value set label array.
            NSArray *noData = @[@"No name set.", @"No website set.", @"No description set.", @"No email set."];
            
            // Now set the labels/buttons accordingly.
            // Check for any nil/NULL/Blank values first.
            for (int loop = 0; loop < 4; loop++) {
                
                NSString *currentString = [parsedData objectAtIndex:loop];
                
                if ((currentString == nil) || (currentString == NULL) || ([currentString isEqualToString:@"<null>"]) || ([currentString isEqualToString:@""])) {
                    [parsedData replaceObjectAtIndex:loop withObject:[NSString stringWithFormat:@"%@", noData[loop]]];
                }
            }
            
            // Set the various labels.
            _userFullName.text = [NSString stringWithFormat:@"%@", parsedData[0]];
            _userWebsiteURL.text = [NSString stringWithFormat:@"%@", parsedData[1]];
            _userDescription.text = [NSString stringWithFormat:@"%@", parsedData[2]];
            _userEmailAddress.text = [NSString stringWithFormat:@"%@", parsedData[3]];
            _userPassword.text = [NSString stringWithFormat:@"%@", passInPass];
            
            // Download the user's profile image.
            UIImage *profileImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", [profileInfo valueForKey:@"image"]]]]];
            
            if (profileImage != nil) {
                [_userProfileImage setImage:profileImage];
            }
        }
        
        else {
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            [self displayErrorAlert:[NSString stringWithFormat:@"%@", error_msg]];
        }
    }
    
    else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        [self displayErrorAlert:[NSString stringWithFormat:@"%@", requestError]];
    }
}

/// IMAGE PICKER DELEGATE METHODS ///

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Store the photo if one has been taken.
    chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (imageType == 1) {
        
        // Save the image to the users library
        // if the photo was taken via the camera.
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    }
    
    // Allow changes to be saved.
    _saveButton.userInteractionEnabled = YES;
    _saveButton.alpha = 1.0;
    
    // Now dismiss the picker view and add
    // the image to the profile picture button.
    [picker dismissViewControllerAnimated:YES completion:^{
        [_userProfileImage setImage:chosenImage];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// OTHER METHODS ///

-(void)displayErrorAlert:(NSString *)errorMessage {
    
    // Display the info alert.
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the alert actions.
    UIAlertAction *dismiss = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    
    // Add the action and present the alert.
    [alert addAction:dismiss];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // Allow changes to be saved.
    _saveButton.userInteractionEnabled = YES;
    _saveButton.alpha = 1.0;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
