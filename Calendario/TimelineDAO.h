//
//  TimelineDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/1/14.
//
//

#import <Foundation/Foundation.h>

@interface TimelineDAO : NSObject

/**
 Downloads all data from table Timeline
 
 @return NSDictionary
 */
- (NSDictionary *)downloadTimeline;

- (void)uploadTimeline;

@end
