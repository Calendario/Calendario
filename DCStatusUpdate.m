//
//  DCStatusUpdate.m
//  Calendario
//
//  Created by Derek Cacciotti on 9/25/15.
//
//

#import "DCStatusUpdate.h"
#import "AFNetworking.h"



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

-(NSString *)getUrl
{
    return [NSString stringWithFormat:@"%@",self.website];
}

-(NSDate *)gettimedata
{
    return self.timeData;
}

-(void)sendData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // bitbucket parameters
    NSDictionary *params = @{
    @"user": [NSNumber numberWithInt:1],
    @"desciption": self.updatetext,
    @"type": [NSNumber numberWithInt:1],
    @"action": [NSNumber numberWithInt:1],
    @"date": self.timeData,

    
    

    };
    
    [manager POST:@" http://calendario.co.uk/publish/" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}








// AFnetworking and JSON Methods, may contains bug













@end
