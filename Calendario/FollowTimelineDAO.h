//
//  FollowTimelineDAO.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 9/22/14.
//
//

#import <Foundation/Foundation.h>

@interface FollowTimelineDAO : NSObject

/**
 Downloads all data from table FollowTimeline
 
 @return NSDictionary
 */
- (NSDictionary *)downloadFollowTimeline;

- (void)uploadFollowTimeline;

@end
