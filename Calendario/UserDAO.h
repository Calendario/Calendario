//
//  UserDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

@import Foundation; //i always try to import using Modules like this - quite a new thing

@interface UserDAO : NSObject


/**
 Downloads all data from table User
 
 @return NSDictionary
 */
- (void)downloadUser;

/**
 Uploads a user and its data to the database
 
 @return void
 */
- (void)uploadUser;

@end
