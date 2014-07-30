//
//  User.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 7/30/14.
//
//

#import "User.h"

@implementation User
@synthesize idUser = _idUser;
@synthesize userName = _userName;
@synthesize password = _password;
@synthesize emailAddress = _emailAddress;
@synthesize idTimeline = _idTimeline;

- (void)register:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email
{
    // Method logic goes here ...
}

- (BOOL)login:(NSString *)userName passWord:(NSString *)passWord
{
    BOOL isLoged = FALSE;
    
    // Method logic goes here ...
    
    return isLoged;
}

- (void)followUser:(NSInteger)idUserFollow idUserBeenFollowed:(NSInteger)idUserBeenFollowed
{
    // Method logic goes here ...
}

- (void)followTimeline:(NSInteger)idTimeline idUserFollow:(NSInteger)idUserFollow
{
    // Method logic goes here ...
}

- (void)acceptFollowRequest:(NSInteger)idRequest
{
    // Method logic goes here ...
}
@end
