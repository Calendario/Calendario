//
//  FacebookLogin.h
//  Calendario
//
//  Created by Harith Bakri on 11/28/14.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookLogin : UIViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
