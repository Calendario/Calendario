//
//  DCStatusUpdate.m
//  Calendario
//
//  Created by Derek Cacciotti on 9/25/15.
//
//

#import "DCStatusUpdate.h"

@implementation DCStatusUpdate

-(id)initWithText:(NSString *)text withWebsite:(NSString*)website AndDate:(NSDate*) date
{
    self = [super init];
    self.updatetext = text;
    self.website = website;
    self.timeData = date;
    
    return self;
}

-(NSString *)getUpdateText
{
    return [NSString stringWithFormat:@"%@",self.updatetext];
}





@end
