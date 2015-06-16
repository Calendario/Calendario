//
//  FollowUserAccount.h
//  Calendario
//
//  Created by Daniel Sadjadian on 16/06/2015.
//
//

#import <Foundation/Foundation.h>

@interface FollowUserAccount : NSObject

-(NSArray *)followUserAccount:(int)userFollow;
-(int)getUserID;

@end


/*
 
 INSTRUCTIONS - In order to use this class from whatever
 class/viewcontroller, please follow the steps listed below:
 
 In your header file add the following:
 1) #import "FollowUserAccount.h"
 2) FollowUserAccount *userData;
 3) @property (nonatomic, retain) FollowUserAccount *userData;
 
 In your implementation file add the following method:
 
 -(void)followAUser:(int)userID {
 
    self.userData = [[FollowUserAccount alloc] init];
    NSArray *responseData = [self.userData followUserAccount:userID];
 
    // User follow response info.
    // Returned in the form of an array like so:
    // [@ 1 or 0, @"string response message"].
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:[NSString stringWithFormat:@"%@", responseData[1]] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
 }
 
 You can call the method like so:
 
 [self followAUser: ... user ID number ... ];
 
 */