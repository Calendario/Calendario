//
//  StatusUpdate.h
//  Calendario
//
//  Created by Osvaldo Livondeni on 7/30/14.
//
//

#import <Foundation/Foundation.h>

@interface StatusUpdate : NSObject
// Attributes
@property (nonatomic) NSInteger idStatusUpdate;
@property (nonatomic, strong) NSString *statusUpdate;
@property (nonatomic, strong) NSString *time;
@property (nonatomic) NSInteger day;
@property (nonatomic) NSInteger month;
@property (nonatomic) NSInteger year;
@property (nonatomic, strong) NSString *timeCreated;
@property (nonatomic) NSInteger dayCreated;
@property (nonatomic) NSInteger monthCreated;
@property (nonatomic) NSInteger yearCreated;
@property (nonatomic) NSInteger idUser;

// Methods

/**
 Allows a user to update his status
 
 @param day
        The day the event is going to take place
 
 @param month
        The month the event is going to take place
 
 @param year
        The year the event is going to take place
 
 @param statusUpdate
        The status update content
 
 @param idUser
        The id of the user that did the status update
 
 @return void
 */
- (void)updateStatus:(NSInteger)day month:(NSInteger)month year:(NSInteger)year statusUpdate:(NSString *)statusUpdate idUser:(NSInteger)idUser;

/**
 Retrieves status updates from users followed by idUserFollow
 
 @param idUserFollow
        The id of the user who follows
 
 @return void
 */
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow;

/**
 Allows a user to like a status update
 
 @param idUser
        The user that likes the status update
 
 @param idStatusUpdate
        The id of the liked status update
 
 @return void
 */
- (void)likeStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;

/**
 Allows a user to comment a status update
 
 @param idUser
        The user that likes the status update
 
 @param idStatusUpdate
        The id of the liked status update
 
 @return void
 */
- (void)commentStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;

/**
 Allows a user to copy the web URL link of a status update
 
 @param idStatusUpdate
        The id of the liked status update
 
 @return The web URL link of the status update
 */
- (NSString *)copyURL:(NSInteger)idStatusUpdate;

/**
 Allows a user to report a status update as inappropriate
 
 @param idUser
        The user who reports the status update
 
 @param idStatusUpdate
        The id of the liked status update
 
 @return The web URL link of the status update
 */
- (void)report:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;

/**
 Retrieves status updates of a month from users followed by idUserFollow
 
 @param idUserFollow
        The id of the user who follows
 
 @param month
        The month to get status updates of
 
 @param year
        The year to get status updates of
 
 @return An array of status updates
 */
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow month:(NSInteger)month year:(NSInteger)year;

/**
 Retrieves status updates of a day of the month from users followed by idUserFollow
 
 @param idUserFollow
        The id of the user who follows
 
 @param month
        The day to get status updates of
 
 @param month
        The month to get status updates of
 
 @param year
        The year to get status updates of
 
 @return An array of status updates
 */
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
@end
