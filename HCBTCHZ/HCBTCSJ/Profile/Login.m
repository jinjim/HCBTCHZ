//
//  Login.m
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "Login.h"

@implementation Login

+(instancetype)sharedInstance
{
    static dispatch_once_t onceTocken;
    __strong static id shareObject;
    dispatch_once(&onceTocken, ^{
        shareObject = [[self alloc] init];
    });
    return shareObject;
}

-(id)init
{
    if (self = [super init]) {
        self.user = [UserModel new];
    }
    BOOL hadLogined = [[[NSUserDefaults standardUserDefaults] objectForKey:@"loginUser"] boolValue];
    if (hadLogined == YES){
        NSData *userData = [[NSUserDefaults standardUserDefaults] objectForKey:@"loginedUser"];
        UserModel *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        [self login:user];
    }
    return self;
}

-(NSString *)userID
{
    if(self.user.UserId.length > 0)
    {
        return self.user.UserId;
    }
    else
    {
        return @"0";
    }
}
-(void)login:(UserModel *)loginUser
{
    self.user = loginUser;
    self.isLogined = YES;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"loginUser"];
    NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:loginUser];
    [[NSUserDefaults standardUserDefaults] setObject:userData forKey:@"loginedUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    postNWithInfo(kNotificationLoginSuccess, nil);
}
-(void)logout
{
    self.user = nil;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"loginUser"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"loginedUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
