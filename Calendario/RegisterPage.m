//
//  RegisterPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import "RegisterPage.h"
#import "KeychainItemWrapper.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface RegisterPage () {
    
    // Alert which appears after registration.
    UIAlertView *successAlert;
    
    // Keychain wrapper class instance.
    KeychainItemWrapper *keychain;
    
    // Alert type.
    // 1 = No action needed.
    // 2 = Show the home view.
    // 3 = Photo selecter.
    int alertType;
    
    // Profile picture.
    UIImage *chosenImage;
    
    // Image type.
    // 1 = library, 2 = camera photo.
    int imageType;
}

@end

@implementation RegisterPage

-(void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Create instance of NSUSerDefaults.
    NSUserDefaults *defaults;
    defaults = [NSUserDefaults standardUserDefaults];
    
    [self.doneButton.layer setCornerRadius:5.0];
    
    // Set the scroll view properties.
    [_registerScroll setScrollEnabled:YES];
    [_registerScroll setContentSize:CGSizeMake(self.view.bounds.size.width, 800)];
    
    // Roudn the edges of the picture button.
    _pictureButton.layer.cornerRadius = 36;
    _pictureButton.layer.masksToBounds = YES;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkPasswordsMatch {
    
    // Check that the two apssword fields are identical.
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        
        NSLog(@"passwords match!");
        [self registerNewUserV2];
    }
    
    else {
        alertType = 1;
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
}

-(IBAction)backgroundTab:(id)sender {
    [self.view endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        [_descriptionField resignFirstResponder];
    }
    
    return YES;
}

-(IBAction)doneButton:(id)sender {
    
    // Check if all text fields are completed.
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""])
    {
        
        alertType = 1;
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (IBAction)addImage:(id)sender {
    
    alertType = 3;
    
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Would you like to use an existing image or take new a photo?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Photo Library", @"Take Photo", nil];
    [error show];
}

-(void)registerNewUserV2 {
    
    // Setup the register POST request.
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@register", webServiceAddress]]];
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
    NSString *postString = [NSString stringWithFormat:@"username=%@&password=%@&emailuser=%@&fullname=%@&website=%@&image=%@&description=%@", _usernameField.text, _passwordField.text, _emailField.text, _fullNameField.text, _websiteField.text, imageString, _descriptionField.text];
    
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
            // The registration has been completed,
            // go on to saving the user details locally.
            [self saveUserData];
        }
        
        else {
            
            // There has been an error so delete the username
            // and password from the keychain.
            [keychain resetKeychainItem];
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)responseData[@"error_message"];
            
            // Display the error message to the user.
            alertType = 1;
            
            UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:error_msg delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
            
            [errorAlert show];
        }
    }
    
    else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        alertType = 1;
        
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        
        [errorAlert show];
    }
}

-(void)saveUserData {
    
    // Securely save username and password to the Keychain.
    keychain = [[KeychainItemWrapper alloc] initWithIdentifier:@"UserLoginData" accessGroup:nil];
    [keychain setObject:_usernameField.text forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:_passwordField.text forKey:(__bridge id)kSecValueData];
    
    // Alert the user of the account creation success.
    alertType = 2;
    
    successAlert = [[UIAlertView alloc] initWithTitle:@"Welcome" message:@"You have been registered. Press OK to continue." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [successAlert show];
}

// UIAlertView delegate methods.

-(void)alertView:(UIAlertView *)successAlert clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // Alert type.
    // 1 = No action needed.
    // 2 = Show the home view.
    // 3 = Photo selecter.
    
    if (alertType == 1) {
        // No action needed.
    }
    
    else if (alertType == 2) {
        
        if (buttonIndex == 0) {
            
            // Now present the home view.
            AppDelegate *reference = [[UIApplication sharedApplication]delegate];
            reference.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *viewController = [storyboard instantiateViewControllerWithIdentifier: @"tabBar"];
            reference.window.rootViewController = viewController;
            [reference.window makeKeyAndVisible];
        }
    }
    
    else if (alertType == 3) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        
        if (buttonIndex == 1) {
            
            // Photo library.
            imageType = 1;
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                
                picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self presentViewController:picker animated:YES completion:NULL];
            }
            
            else {
                
                // No action is needed.
                alertType = 1;
                
                // Display the camera error alert.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error accessing your photo library. Make sure you have granted Calendario access to your photos." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
        
        else if (buttonIndex == 2) {
            
            // Take a new image.
            imageType = 2;
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                
                if ([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront]) {
                    picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                
                [self presentViewController:picker animated:YES completion:NULL];
            }
            
            else {
                
                // No action is needed.
                alertType = 1;
                
                // Display the camera error alert.
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You can not take a photo because your device does not have a camera." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}

// Image picker delegate methods.

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    // Store the photo if one has been taken.
    chosenImage = info[UIImagePickerControllerEditedImage];
    
    if (imageType == 2) {
        
        // Save the image to the users library
        // if the photo was taken via the camera.
        UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil);
    }
    
    // Now dismiss the picker view and add
    // the image to the profile picture button.
    [picker dismissViewControllerAnimated:YES completion:^{
        [_pictureButton setBackgroundImage:chosenImage forState:UIControlStateNormal];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
