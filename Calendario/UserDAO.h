//
//  UserDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

#import <Foundation/Foundation.h>

@interface UserDAO : NSObject

/**
 Downloads all data from table User
 
 @return NSDictionary
 */
- (NSDictionary *)downloadUser;

/**
 Uploads a user and its data to the database
 
 @return void
 */
- (void)uploadUser;

@end
