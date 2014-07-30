//
//  User.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 7/30/14.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject
// Attributes
@property (nonatomic) NSInteger idUser;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *emailAddress;
@property (nonatomic) NSInteger idTimeline;

// Methods

/**
 Create a new user account
 
 @param userName
        The new user's name
 
 @param password
        The new user’s password
 
 @param mail
        The new user's mail
 
 @return void
*/
- (void)register:(NSString *)userName passWord:(NSString *)passWord email:(NSString *)email;
- (BOOL)login:(NSString *)userName passWord:(NSString *)passWord;
- (void)followUser:(NSInteger)idUserFollow idUserBeenFollowed:(NSInteger)idUserBeenFollowed;
- (void)followTimeline:(NSInteger)idTimeline idUserFollow:(NSInteger)idUserFollow;
- (void)acceptFollowRequest:(NSInteger)idRequest;
@end
