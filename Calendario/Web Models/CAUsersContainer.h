//
//  CAUsersContainer.h
//  
//
//  Created by lee Burrows on 17/11/2014.
//  Copyright (c) 2014 LDB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CAUsersContainer : NSObject {
    NSMutableArray *users;
}

@property (nonatomic, copy) NSMutableArray *users;

+ (CAUsersContainer *)instanceFromDictionary:(NSDictionary *)aDictionary;
- (void)setAttributesFromDictionary:(NSDictionary *)aDictionary;

@end
