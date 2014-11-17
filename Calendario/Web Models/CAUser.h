//
//  CAUser.h
//  
//
//  Created by lee Burrows on 17/11/2014.
//  Copyright (c) 2014 LDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAUser : NSObject {
    NSString *emailAddress;
    NSString *fullName;
    NSString *idTimeline;
    NSString *password;
    NSString *cAUserId;
    NSString *userName;
}

@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *idTimeline;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *cAUserId;
@property (nonatomic, copy) NSString *userName;

+ (CAUser *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
