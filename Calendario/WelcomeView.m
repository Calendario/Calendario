//
//  WelcomeView.m
//  Calendario
//
//  Created by Harith Bakri on 1/12/15.
//
//

#import "WelcomeView.h"

@interface WelcomeView ()
@property (nonatomic, strong) NSArray * FBPermissions;
@end

@implementation WelcomeView

static WelcomeView * instance;

- (id)init
{
    if (self=[super init])
    {
        self.FBPermissions = @[@"basic_info"];
    }
    return self;
}


+ (id)sharedAccount
{
    if (instance == Nil) {
        instance = [[WelcomeView alloc] init];
    }
    return instance;
}



- (void)applicationDidFinishLaunchingWithOptions
{
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        
        [FBSession openActiveSessionWithReadPermissions:self.FBPermissions
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
    }
    
}


- (BOOL)fbLogInLogOut
{
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        [FBSession.activeSession closeAndClearTokenInformation];
        return NO;
    }
    else
    {
        [FBSession openActiveSessionWithReadPermissions:self.FBPermissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
         {
             [self sessionStateChanged:session state:state error:error];
         }];
        return YES;
    }
    
}



-(void)applicationDidBecomeActive
{
    [FBAppCall handleDidBecomeActive];
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         [self sessionStateChanged:session state:state error:error];
         
     }];
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
}


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        NSLog(@"Session closed");
        [self userLoggedOut];
    }
    
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
            [alert show];
            //            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                [alert show];
                //                [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertText delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: nil];
                [alert show];
                //                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

- (void)userLoggedIn
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error)
        {
            NSLog(@"user info: %@", result);
            
        } else
        {
            NSLog(@"Error");
        }
    }];
    
    NSLog(@"logIn");
    
}

- (void)userLoggedOut
{
    NSLog(@"logOut ok");
    
}



@end
