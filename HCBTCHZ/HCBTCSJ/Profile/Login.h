//
//  Login.h
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Login : NSObject
@property (strong, nonatomic) UserModel *user;
@property (copy, nonatomic) NSString *registrationID;
@property (assign, nonatomic) BOOL isLogined;

- (NSString *)userID;
+ (Login *)sharedInstance;

- (void)login:(UserModel *)loginUser;
- (void)logout;
@end
