//
//  ForgotPassword.m
//  Calendario
//
//  Created by Harith Bakri on 3/18/15.
//
//

#import "ForgotPassword.h"

@interface ForgotPassword ()

@end

@implementation ForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)forgotPassword {
    
    // Get the current date/time string.
    NSDate *currentTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddhhmmss"];
    NSString *resultDate = [dateFormatter stringFromDate: currentTime];
    
    // Create the URL to the User Register PHP file.
    NSString *urlFormatted = [NSString stringWithFormat:@"%@forgotpassword/%@/%@/%@/", webServiceAddress, _txtEmailaddress.text, resultDate];
    
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
        
        // Get the JSON data and parse it.
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingMutableContainers error:&error];
        
        // Check the responce for a success.
        NSString *successString = [jsonData objectForKey:@"msg"];
        
        if ([successString isEqualToString:@"sucess"] || [successString isEqualToString:@"success"]) {
            
            // The login has been completed,
            // go on to alert and then home view.
            [self alertStatus:@"Successfully Sent." :@"Success" :1];
        }
        
        else {
            
            // Parse the error message passed back from the server.
            NSString *error_msg = (NSString *)jsonData[@"error_message"];
            
            // Display the error message to the user.
            [self alertStatus:error_msg :@"Session Error" :0];
        }
    }
    
    else {
        
        // There has been an issue with the connection
        // to the server - probably internet connection.
        [self alertStatus:[NSString stringWithFormat:@"%@", requestError] :@"Error" :0];
    }
}
- (IBAction)fowardClicked:(id)sender {
    [self forgotPassword];
}

-(void)alertStatus:(NSString *)msg :(NSString *)title :(int)tag {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    alertView.tag = tag;
    
    [alertView show];
}
//Dismiss Keyboard
- (IBAction)backgroundTap:(id)sender {
     [self.view endEditing:YES];
}


- (BOOL) UITextFieldShouldReturn:(UITextField *) textField{
    [textField resignFirstResponder];
    return YES;
}


@end
