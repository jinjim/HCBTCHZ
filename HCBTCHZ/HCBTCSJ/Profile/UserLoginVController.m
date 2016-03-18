//
//  UserLoginVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/23.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "UserLoginVController.h"

@interface UserLoginVController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtPasswd;

@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@end

@implementation UserLoginVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    self.btnRegister.layer.borderColor = KNavigationBarColor.CGColor;
    self.btnRegister.layer.borderWidth = 1.0;
    self.btnRegister.layer.cornerRadius = 5.0;
    
    UIView *leftPhoneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgPhoneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_tel"]];
    imgPhoneView.frame = CGRectMake(15, 12, 15, 15);
    [leftPhoneView addSubview:imgPhoneView];
    UIView *leftPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    UIImageView *imgPwdView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd"]];
    imgPwdView.frame = CGRectMake(15, 12, 15, 15);
    [leftPwdView addSubview:imgPwdView];
    self.txtUserName.leftView = leftPhoneView;
    self.txtPasswd.leftView = leftPwdView;
    self.txtUserName.leftViewMode = UITextFieldViewModeAlways;
    self.txtPasswd.leftViewMode = UITextFieldViewModeAlways;
    self.txtUserName.delegate = self;
    self.txtPasswd.delegate = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 键盘事件
- (void)keyboardExit
{
    [self.txtUserName resignFirstResponder];
    [self.txtPasswd resignFirstResponder];
    [UIView animateWithDuration:0.2 animations:^{
        self.view.top = 0;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        self.view.top = -50;
    }];
}

#pragma mark - 登录注册忘记密码点击事件
// 登录
- (IBAction)btnLoginClick
{

    NSString *cellPhone = [self.txtUserName.text trimString];
    if ([cellPhone isEmpty]) {
        [self showResultThenHide:@"请输入手机号!"];
        return ;
    }
    if (![cellPhone isMobilePhone]) {
        [self showResultThenHide:@"请输入正确手机号码!"];
        return ;
    }
    NSString *passwd = [self.txtPasswd.text trimString];
    if ([passwd isEmpty]) {
        [self showResultThenHide:@"请输入密码!"];
        return ;
    }

    NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
    [dictParam setObject:cellPhone forKey:@"username"];
    [dictParam setObject:passwd forKey:@"pwd"];

    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KLogin andDictParam:dictParam requestSuccessed:^(id responseObject) {
        [self showResultThenHide:@"登录成功"];
        UserModel *user = [UserModel mj_objectWithKeyValues:responseObject];
        [[Login sharedInstance] login:user];
        [self backup];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:@"登录失败"];
    }];
}

// 注册
- (IBAction)btnRegisterClick
{
    [self pushViewController:@"RegisterVController" withParams:@{@"operateType":@"0"}];
}

// 忘记密码
- (IBAction)btnForgetPasswd
{
    [self pushViewController:@"RegisterVController" withParams:@{@"operateType":@"1"}];
}
// 呼叫客服
- (IBAction)btnCallService
{
    
}
@end
