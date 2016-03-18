//
//  RegisterVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/24.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "RegisterVController.h"


@interface RegisterVController ()
{
    NSInteger operateType;
    BOOL bAgree;
}
@property (copy, nonatomic) NSString *checkCode;
@property (copy, nonatomic) NSString *vehicleID;

@property (weak, nonatomic) IBOutlet UITextField *txtCellPhone;
@property (weak, nonatomic) IBOutlet UITextField *txtCheckCode;
@property (weak, nonatomic) IBOutlet UIButton *btnGetMsg;
@property (weak, nonatomic) IBOutlet UILabel *lbGetMsg;
@property (weak, nonatomic) IBOutlet UITextField *txtPwd;
@property (weak, nonatomic) IBOutlet UITextField *txtPwdConfirm;
@property (weak, nonatomic) IBOutlet UIView *chkBoxAgreeView;
@property (weak, nonatomic) IBOutlet UIImageView *imgChkBox;



@property (weak, nonatomic) IBOutlet UILabel *lbProtocal;
@end

@implementation RegisterVController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lbProtocal.textColor = KNavigationBarColor;
    operateType = [self.params[@"operateType"] integerValue];
    self.navigationItem.title = (operateType == 0)?@"新用户注册":@"找回密码";
    self.vehicleID = @"";
    self.checkCode = @"NoCode";
    bAgree = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    [self.chkBoxAgreeView bk_whenTapped:^{
        bAgree = !bAgree;
        NSString *imageName = (bAgree)?@"chkBox_select":@"chkBox_noselect";
        [self.imgChkBox setImage:[UIImage imageNamed:imageName]];
    }];
}

// 获取验证码
- (IBAction)btnGetMsgClick
{
    NSString *cellPhone = [self.txtCellPhone.text trimString];
    if ([cellPhone isEmpty]) {
        [self showResultThenHide:@"请输入手机号!"];
        return ;
    }
    if (![cellPhone isMobilePhone]) {
        [self showResultThenHide:@"请输入正确手机号码!"];
        return ;
    }
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:cellPhone forKey:@"Phone"];

    
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KSendMessage andDictParam:dictParam requestSuccessed:^(id responseObject) {
            // 多线程执行时间倒数
            __block int timeout = 60; // 倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
            dispatch_source_set_event_handler(timer, ^{
                if (timeout <= 0)  // 倒计时结束
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.checkCode = @"NoCode";
                        [self.btnGetMsg setUserInteractionEnabled:YES];
                        [self.btnGetMsg setTitle:@"获取验证码" forState:UIControlStateNormal];
                        [self.btnGetMsg setBackgroundImage:[UIImage imageNamed:@"btnBlue.png"] forState:UIControlStateNormal];
                        [self.lbGetMsg setText:@""];
                    });
                    dispatch_source_cancel(timer);
                }
                else
                {
                    NSString *strTime = [NSString stringWithFormat:@"重新获取(%d)",timeout];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.btnGetMsg setUserInteractionEnabled:NO];
                        [self.btnGetMsg setTitle:@"" forState:UIControlStateNormal];
                        [self.btnGetMsg setBackgroundImage:[UIImage imageNamed:@"btnGray.png"] forState:UIControlStateNormal];
                        [self.lbGetMsg setText:strTime];
                    });
                    timeout--;
                }
            });
            dispatch_resume(timer);
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:errorMessage];
    }];
}

// 注册按钮点击
- (IBAction)btnOKClick
{
    NSString *phone = self.txtCellPhone.text.trimString;
    NSString *chkCode = self.txtCheckCode.text.trimString;
    NSString *pwd = self.txtPwd.text.trimString;
    NSString *pwdConfirm = self.txtPwdConfirm.text.trimString;
    if (phone.isEmpty) {
        [self showResultThenHide:@"请获取验证码！"];
        return ;
    }
    if (chkCode.isEmpty) {
        [self showResultThenHide:@"请填写验证码！"];
        return ;
    }
    if (pwd.isEmpty) {
        [self showResultThenHide:@"请输入密码！"];
        return ;
    }
    
    if (![pwd isEqualToString:pwdConfirm]) {
        [self showResultThenHide:@"两次输入密码不符合！"];
        return ;
    }
    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:phone forKey:@"PhoneNo"];
    [dictParam setObject:pwd forKey:@"NewPwd"];
    [dictParam setObject:chkCode forKey:@"code"];
    
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KRegister andDictParam:dictParam requestSuccessed:^(id responseObject) {
        [self showResultThenHide:@"注册成功"];
        UserModel *user = [UserModel mj_objectWithKeyValues:responseObject];
        [[Login sharedInstance] login:user];
        [self backup];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:errorMessage];
    }];
}

@end
