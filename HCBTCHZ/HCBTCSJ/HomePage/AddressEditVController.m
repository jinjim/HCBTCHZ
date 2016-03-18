//
//  AddressEditVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/4.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "AddressEditVController.h"
#import "AddrMapVController.h"

@interface AddressEditVController ()<AddressSearchDelegate>
{
    NSInteger operateType;
}
@property (retain, nonatomic) AddressModel *address;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *lbAddress;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressDetail;
@property (weak, nonatomic) IBOutlet UITextField *txtRecvName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;

@end

@implementation AddressEditVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnOK)];
    operateType = [self.params[@"type"] integerValue];
    // 编辑地址
    if (operateType == 1) {
        self.address = self.params[@"address"];
        self.navigationItem.title = @"编辑地址";
        [self updateAddressInfo];
    }
    else{
        self.navigationItem.title = @"添加地址";
    }
    
    [self.addressView bk_whenTapped:^{
        AddrMapVController *addrMap = [[AddrMapVController alloc] init];
        addrMap.delegate = self;
        [self.navigationController pushViewController:addrMap animated:YES];
    }];
    
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapRegister];
}

- (void)btnOK
{
    if (self.address == nil) {
        [self showResultThenHide:@"请选择地址"];
        return ;
    }
    if (self.txtRecvName.text.trimString.length == 0) {
        [self showResultThenHide:@"请输入收货人姓名"];
        return ;
    }
    if (self.txtPhoneNum.text.trimString.length == 0) {
        [self showResultThenHide:@"请输入联系电话"];
        return ;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[Login sharedInstance].userID forKey:@"UserID"];
    [dict setObject:self.lbAddress.text.trimString forKey:@"addressName"];
//    [dict setObject:self.txtAddressDetail.text.trimString forKey:@"addressDetailName"];
    [dict setObject:self.txtRecvName.text.trimString forKey:@"consignee"];
    [dict setObject:self.txtPhoneNum.text.trimString forKey:@"phone"];
    [dict setObject:@(self.address.Longitude) forKey:@"longitude"];
    [dict setObject:@(self.address.Latitude) forKey:@"latitude"];
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KSaveCommonAddress andDictParam:dict requestSuccessed:^(id responseObject) {
        NSLog(@"%@",responseObject);
        [self showResultThenHide:responseObject];
        [self backup];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        NSLog(@"%@",errorMessage);
        [self showResultThenHide:errorMessage];
    }];
}

- (void) didSelectSearchAddress:(AddressModel *)address
{
    self.address = address;
    self.address.Consignee = @"";
    self.address.ContactPhone = @"";
    [self updateAddressInfo];
}

// 更新地址界面
- (void)updateAddressInfo
{
    if (self.address) {
        self.lbAddress.text = self.address.AddressName;
        self.txtAddressDetail.text = self.address.addressDetailName;
        self.txtRecvName.text = self.address.Consignee;
        self.txtPhoneNum.text = self.address.ContactPhone;
    }
}


#pragma mark - keyboardExit
- (void)keyboardExit
{
    [self.txtAddressDetail resignFirstResponder];
    [self.txtRecvName resignFirstResponder];
    [self.txtPhoneNum resignFirstResponder];
}

@end
