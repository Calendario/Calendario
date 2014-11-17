//
//  UserDAO.m
//  Calendario
//
//  Created by Osvaldo Livondeni on 8/29/14.
//
//

#import "UserDAO.h"
#import "CAUsersContainer.h"
@interface UserDAO ()

@property (nonatomic, strong) CAUsersContainer *userContainer;

@end

@implementation UserDAO

- (void)downloadUser
{

#warning LB TODO - Completion Black param
    /**
     *  create the manager || LB TODO
     */
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //get
    [manager GET:[NSString stringWithFormat:@"%@User.php", webServiceAddress] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
         _userContainer = [CAUsersContainer instanceFromDictionary:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [SVProgressHUD showErrorWithStatus:@"Error"];
    }];
    
}
- (void)uploadUser
{
    // AFNetworking code to upload goes here
}

@end
