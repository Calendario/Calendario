//
//  CAUser.m
//  
//
//  Created by lee Burrows on 17/11/2014.
//  Copyright (c) 2014 LDB. All rights reserved.
//

#import "CAUser.h"

@implementation CAUser

+ (CAUser *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CAUser *instance = [[CAUser alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"id"]) {
        [self setValue:value forKey:@"cAUserId"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


@end
