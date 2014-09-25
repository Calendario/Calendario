//
//  FollowUserDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import <Foundation/Foundation.h>

@interface FollowUserDAO : NSObject

/**
 Downloads all data from table FollowUser
 
 @return NSDictionary
 */
- (NSDictionary *)downloadFollowUser;

- (void)uploadFollowUser;

@end
