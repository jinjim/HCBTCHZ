//
//  ResetPWDVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/25.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ResetPWDVController.h"

@interface ResetPWDVController ()
{
    NSString *cellPhoneNO;
    NSString *checkCode;
}
@property (weak, nonatomic) IBOutlet UITextField *txtNewPasswd;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswdConfirm;

@end

@implementation ResetPWDVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    cellPhoneNO = self.params[@"cellPhoneNO"];
    checkCode = self.params[@"checkCode"];
    
    self.navigationItem.title = @"重置密码";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置密码
- (IBAction)btnResetPasswd
{
    NSString *newPasswd = self.txtNewPasswd.text.trimString;
    NSString *passwdConfirm = self.txtPasswdConfirm.text.trimString;
    if (newPasswd.isEmpty) {
        [self showResultThenHide:@"请输入密码"];
        return ;
    }
    if (![newPasswd isEqualToString:passwdConfirm]) {
        [self showResultThenHide:@"两次密码不一致，请重新输入"];
        return ;
    }
    
    NSDictionary *paramDict = @{@"pinNo":checkCode,@"phoneNo":cellPhoneNO,@"newPwd":newPasswd};
}


@end
