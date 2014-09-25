//
//  StatusUpdateDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import <Foundation/Foundation.h>

@interface StatusUpdateDAO : NSObject

/**
 Downloads all data from table StatusUpdate
 
 @return NSDictionary
 */
- (NSDictionary *)downloadStatusUpdate;

- (void)uploadStatusUpdate;

@end
