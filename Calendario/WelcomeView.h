//
//  WelcomeView.h
//  Calendario
//
//  Created by Harith Bakri on 1/12/15.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
@interface WelcomeView : NSObject
+ (id)sharedAccount;
- (BOOL)fbLogInLogOut;
- (void)applicationDidFinishLaunchingWithOptions;
-(void)applicationDidBecomeActive;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;



@end
@end
