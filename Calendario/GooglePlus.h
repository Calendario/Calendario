//
//  GooglePlus.h
//  Calendario
//
//  Created by Harith Bakri on 11/29/14.
//
//

#import <UIKit/UIKit.h>

#import <GooglePlus/GooglePlus.h>
@class GPPSignInButton;

@interface GooglePlus : UIViewController <GPPSignInDelegate>
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;
@end
