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
- (void)updateStatus:(NSInteger)day month:(NSInteger)month year:(NSInteger)year statusUpdate:(NSString *)statusUpdate idUser:(NSInteger)idUser;
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow;
- (void)likeStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;
- (void)commentStatusUpdate:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;
- (NSString *)copyURL:(NSInteger)idStatusUpdate;
- (void)report:(NSInteger)idUser idStatusUpdate:(NSInteger)idStatusUpdate;
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow month:(NSInteger)month year:(NSInteger)year;
- (NSArray *)retrieveStatusUpdate:(NSInteger)idUserFollow day:(NSInteger)day month:(NSInteger)month year:(NSInteger)year;
@end
