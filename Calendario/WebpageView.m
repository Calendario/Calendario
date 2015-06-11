//
//  WebpageView.m
//  Calendario
//
//  Created by Daniel Sadjadian on 11/06/2015.
//
//

#import "WebpageView.h"

@interface WebpageView ()

@end

@implementation WebpageView
@synthesize pass_URL;

/// BUTTONS ///

-(IBAction)done:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openInBrowser:(id)sender {
    
    if ((pass_URL != nil) || (![pass_URL isKindOfClass:[NSNull class]])) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Open in browser" message:@"Would you like to open this link in Safari or Chrome?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *openSafari = [UIAlertAction actionWithTitle:@"Safar" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [alert dismissViewControllerAnimated:YES completion:^{
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pass_URL]];
            }];
        }];
        
        UIAlertAction *openChrome = [UIAlertAction actionWithTitle:@"Chrome" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            [alert dismissViewControllerAnimated:YES completion:^{
                
                // Browser set to Google Chrome.
                NSURL *chromeCheck = [NSURL URLWithString:@"googlechrome://"];
                
                if ([[UIApplication sharedApplication] canOpenURL:chromeCheck]) {
                    
                    NSURL *inputURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", pass_URL]];
                    NSString *scheme = inputURL.scheme;
                    
                    // Replace the URL Scheme with the Chrome equivalent.
                    NSString *chromeScheme = nil;
                    
                    if ([scheme isEqualToString:@"http"]) {
                        chromeScheme = @"googlechrome";
                    }
                    
                    else if ([scheme isEqualToString:@"https"]) {
                        chromeScheme = @"googlechromes";
                    }
                    
                    // Proceed only if a valid Google Chrome URI Scheme is available.
                    if (chromeScheme) {
                        NSString *absoluteString = [inputURL absoluteString];
                        NSRange rangeForScheme = [absoluteString rangeOfString:@":"];
                        NSString *urlNoScheme = [absoluteString substringFromIndex:rangeForScheme.location];
                        NSString *chromeURLString = [chromeScheme stringByAppendingString:urlNoScheme];
                        
                        // Open the URL with Google Chrome.
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:chromeURLString]];
                    }
                }
                
                else {
                    
                    // Google Chrome is not installed, offer Safari instead.
                    
                    UIAlertController *alertSafari = [UIAlertController alertControllerWithTitle:@"Info" message:@"Google Chrome has not been installed on this device. Would you like to open the link in Safari?" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        [alertSafari dismissViewControllerAnimated:YES completion:^{
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pass_URL]];
                        }];
                    }];
                    
                    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        [alertSafari dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [alertSafari addAction:yesButton];
                    [alertSafari addAction:noButton];
                    
                    [self presentViewController:alertSafari animated:YES completion:nil];
                }
            }];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:openSafari];
        [alert addAction:openChrome];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else {
        NSLog(@"Cannot open link in browser, because link is nil");
    }
}

/// VIEW DID LOAD ///

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set the web view background to transparent.
    _webpage.backgroundColor = [UIColor clearColor];
    
    if ((pass_URL == nil) || ([pass_URL isKindOfClass:[NSNull class]])) {
        
        // Do not allow the user to open the link in
        // another browser and the link is invalid.
        _openBrowserButton.userInteractionEnabled = NO;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"The website link you are trying to load, is not a valid link." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
    
    else {
        
        // The URl is valid, allow the user to open it in
        // another browser app if they wish.
        _openBrowserButton.userInteractionEnabled = YES;
        
        // Pass in the URL from the action to the web view.
        [_webpage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:pass_URL]]];
        
        // Setup the activity indicator load checks.
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkLoad) userInfo:nil repeats:YES];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkNotLoad) userInfo:nil repeats:YES];
    }
}

/// OTHER METHODS ///

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    // Make sure we only show this error when the link
    // that is passed in is VALID. Only then can we know
    // that the error is a network error.
    
    if ((pass_URL != nil) || (![pass_URL isKindOfClass:[NSNull class]])) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There appears to be a problem with your internet connection. Please connect to a network and try agsin." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)checkLoad {
    
    if (_webpage.loading) {
        [_active startAnimating];
    }
}

-(void)checkNotLoad {
    
    if (!(_webpage.loading)) {
        [_active stopAnimating];
    }
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
