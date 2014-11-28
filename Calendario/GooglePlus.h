//
//  GooglePlus.h
//  Calendario
//
//  Created by Harith Bakri on 11/29/14.
//
//

#import <UIKit/UIKit.h>

#import <GooglePlus/GooglePlus.h>

@interface GooglePlus : UIViewController <GPPSignInDelegate>
@class GPPSignInButton;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@synthesize signInButton;
@end
