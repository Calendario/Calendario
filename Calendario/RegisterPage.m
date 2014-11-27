//
//  RegisterPage.m
//  Calendario
//
//  Created by Harith Bakri on 11/27/14.
//
//

#import "RegisterPage.h"

@interface RegisterPage ()

@end

@implementation RegisterPage

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //create instance of NSUSerDefaults
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkPasswordsMatch {
    
    //check that the two apssword fields are identical
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]) {
        NSLog(@"passwords match!");
        [self registerNewUser];
    }
    else {
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    
}

- (IBAction)backgroundTab:(id)sender {
    
    [self.view endEditing:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)doneButton:(id)sender {
    //check if all text fields are completed
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""]) {
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
    NSString *post =[[NSString alloc] initWithFormat:@"username=%@&password=%@",[self.usernameField text],[self.passwordField text],[self.emailField],[self.reEnterPasswordField]];
    NSLog(@"PostData: %@",post);
    
    NSURL *url=[NSURL URLWithString:@"http://calendario.emlinha.net/register.php"];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    //[NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[url host]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *response = nil;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSLog(@"Response code: %ld", (long)[response statusCode]);
    
    if ([response statusCode] >= 200 && [response statusCode] < 300)
    {
        NSString *responseData = [[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
        NSLog(@"Response ==> %@", responseData);
        
        NSError *error = nil;
        NSDictionary *jsonData = [NSJSONSerialization
                                  JSONObjectWithData:urlData
                                  options:NSJSONReadingMutableContainers
                                  error:&error];
        
        success = [jsonData[@"success"] integerValue];
        NSLog(@"Success: %ld",(long)success);


- (void) registerNewUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //write the username and password and set BOOL value in NSUserDefaults
    [defaults setObject:_usernameField.text forKey:@"username"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    [defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}
@end
