//
//  UserDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

#import "UserDAO.h"

@interface UserDAO ()
@end

@implementation UserDAO

+ (void)downloadUser:(void (^)(CAUsersContainer * users, NSError * error))completionBlock
{

    /**
     *  create the manager || LB TODO
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //get
    [manager GET:[NSString stringWithFormat:@"%@User.php", webServiceAddress] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        completionBlock([CAUsersContainer instanceFromDictionary:responseObject],nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Error"];
        completionBlock(nil,error);
    }];
    
}
- (void)uploadUser
{
    // AFNetworking code to upload goes here
}

@end
