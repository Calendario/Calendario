//
//  DCStatusUpdate.h
//  Calendario
//
//  Created by Derek Cacciotti on 9/25/15.
//
//

#import <Foundation/Foundation.h>

@interface DCStatusUpdate : NSObject

@property (nonatomic, strong) NSString *updatetext;
@property (nonatomic, strong) NSString *website;
@property (nonatomic, strong) NSDate *timeData;


-(id)initWithText:(NSString *)text withWebsite:(NSString*)website AndDate:(NSDate*) date;


-(NSString *)getUpdateText;




@end
