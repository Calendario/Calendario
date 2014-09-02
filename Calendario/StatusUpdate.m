//
//  StatusUpdate.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 7/30/14.
//
//

#import "StatusUpdate.h"

@implementation StatusUpdate
@synthesize idStatusUpdate = _idStatusUpdate;
@synthesize statusUpdate = _statusUpdate;
@synthesize time = _time;
@synthesize day = _day;
@synthesize month = _month;
@synthesize year = _year;
@synthesize timeCreated = _timeCreated;
@synthesize dayCreated = _dayCreated;
@synthesize monthCreated = _monthCreated;
@synthesize yearCreated = _yearCreated;
@synthesize idUser = _idUser;

- (void)updateStatus:(NSInteger)day month:(NSInteger)month year:(NSInteger)year statusUpdate:(NSString *)statusUpdate idUser:(NSInteger)idUser
{
    // Method logic goes here ...
}

- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow
{
    NSArray *statusUpdates = [[NSArray alloc] init];
    
    // Method logic goes here ...
    
    return statusUpdates;
}

- (void)likeStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate
{
    // Method logic goes here ...
}

- (void)commentStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate
{
    // Method logic goes here ...
}

- (NSString *)copyURL:(NSInteger)idStatusUpdate
{
    NSString *URL = [[NSString alloc] init];
    
    // Method logic goes here ...
    
    return URL;
}

- (void)report:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate
{
    // Method logic goes here ...
}

- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow month:(NSInteger)month year:(NSInteger)year
{
    NSArray *statusUpdates = [[NSArray alloc] init];
    
    // Method logic goes here ...
    
    return statusUpdates;
}

- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year
{
    NSArray *statusUpdates = [[NSArray alloc] init];
    
    // Method logic goes here ...
    
    return statusUpdates;
}
@end
