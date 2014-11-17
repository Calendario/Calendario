//
//  CAUsersContainer.m
//  
//
//  Created by lee Burrows on 17/11/2014.
//  Copyright (c) 2014 LDB. All rights reserved.
//

#import "CAUsersContainer.h"

#import "CAUser.h"

@implementation CAUsersContainer

+ (CAUsersContainer *)instanceFromDictionary:(NSDictionary *)aDictionary {

    CAUsersContainer *instance = [[CAUsersContainer alloc] init];
    [instance setAttributesFromDictionary:aDictionary];
    return instance;

}

- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary {

    if (![aDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }

    [self setValuesForKeysWithDictionary:aDictionary];

}

- (void)setValue:(id)value forKey:(NSString *)key {

    if ([key isEqualToString:@"Users"]) {

        if ([value isKindOfClass:[NSArray class]]) {

            NSMutableArray *myMembers = [NSMutableArray arrayWithCapacity:[value count]];
            for (id valueMember in value) {
                CAUser *populatedMember = [CAUser instanceFromDictionary:valueMember];
                [myMembers addObject:populatedMember];
            }

            self.users = myMembers;

        }

    } else {
        [super setValue:value forKey:key];
    }

}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {

    if ([key isEqualToString:@"Users"]) {
        [self setValue:value forKey:@"users"];
    } else {
        [super setValue:value forUndefinedKey:key];
    }

}


@end
