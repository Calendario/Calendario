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

// AFnetworking and JSON Methods, may contains bug
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
    
    
    NSString *link = @"http://calendario.co.uk/publish/";
    
    NSString *encodedlink = [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager POST:encodedlink parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON : %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(error.localizedDescription);
    }];
    
    
    
    /*[manager POST:encodedlink parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    }];
     */
    
   }






















@end
