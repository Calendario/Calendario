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

/**
 Login an existent user to the system.
 
 @param userName
        The new user's name
 
 @param password
        The new user’s password
 
 @return TRUE if succeeds, FALSE if not
 */
- (BOOL)login:(NSString *)userName passWord:(NSString *)passWord;

/**
 Allows a user to follow another user.
 
 @param idUserFollow
        The id of the user who follows
 
 @param idUserBeenFollowed
        The id of the user been followed
 
 @return void
 */
- (void)followUser:(NSInteger)idUserFollow idUserBeenFollowed:(NSInteger)idUserBeenFollowed;

/**
 Allows a user to follow another user's timeline.
 
 @param idTimeline
        The id of the followed timeline
 
 @param idUserFollow
        The id of the user who follows the timeline
 
 @return void
 */
- (void)followTimeline:(NSInteger)idTimeline idUserFollow:(NSInteger)idUserFollow;

/**
 Allows a user to accept a follow request
 
 @param idRequest
        The id of the request
 
 @return void
 */
- (void)acceptFollowRequest:(NSInteger)idRequest;
@end
