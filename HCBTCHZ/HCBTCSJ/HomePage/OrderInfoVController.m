//
//  FastOrderVController.m
//  HCBTCHZ
//
//  Created by itte on 3/3/16.
//  Copyright © 2016 itte. All rights reserved.
//

#import "OrderInfoVController.h"
#import "AddressListVController.h"
#import "AddrMapVController.h"

@interface OrderInfoVController ()<AddressSelectDelegate,AddressSearchDelegate,UITextViewDelegate>
{
    NSInteger operateType;
    BOOL bCommonAddress;        // 是否保存为常用地址
    BOOL bExtraServiceBack;     // 是否额外服务返回
    BOOL bExtraService1;        // 是否额外服务1
    BOOL bExtraService2;        // 是否额外服务2
    BOOL bExtraService3;        // 是否额外服务3
}
@property (retain, nonatomic) AddressModel *address;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *addrSelectView;
@property (weak, nonatomic) IBOutlet UILabel *lbAddressName;
@property (weak, nonatomic) IBOutlet UITextField *txtAddressDetail;
@property (weak, nonatomic) IBOutlet UITextField *txtRecvName;
@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (weak, nonatomic) IBOutlet UIView *choiceView;
@property (weak, nonatomic) IBOutlet UIView *extraServiceSelect;
@property (weak, nonatomic) IBOutlet UIView *serviceView1;
@property (weak, nonatomic) IBOutlet UIView *serviceView2;
@property (weak, nonatomic) IBOutlet UIView *serviceView3;
@property (weak, nonatomic) IBOutlet UIImageView *imgService1;
@property (weak, nonatomic) IBOutlet UIImageView *imgService2;
@property (weak, nonatomic) IBOutlet UIImageView *imgService3;
@property (weak, nonatomic) IBOutlet UITextField *txtMonney;

@property (weak, nonatomic) IBOutlet UIImageView *imgChoice;
@property (weak, nonatomic) IBOutlet UIView *extraServiceView;

@property (weak, nonatomic) IBOutlet UITextView *txtOrtherView;
@property (weak, nonatomic) IBOutlet UIButton *btnOK;

@end

@implementation OrderInfoVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"常用地址" style:UIBarButtonItemStyleDone target:self action:@selector(addAddress)];
    operateType = [self.params[@"type"] integerValue];
    bCommonAddress = NO;
    bExtraServiceBack = NO;
    // 视图初始化
    [self subViewInit];
    
    
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapRegister];
    
}
// 视图初始化
- (void) subViewInit
{
    // 设置滚动视图
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 480);
    [self.scrollView addSubview:self.contentView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 480);
    self.btnOK.layer.cornerRadius = 5;
    
    // 选择是否保存常用地址操作
    [self.choiceView bk_whenTapped:^{
        bCommonAddress = (bCommonAddress)?NO:YES;
        NSString *imgName = (bCommonAddress)?@"icon_save":@"icon_save_pre";
        [self.imgChoice setImage:[UIImage imageNamed:imgName]];
    }];
    // 选择地址
    AddrMapVController *addrMap = [[AddrMapVController alloc] init];
    addrMap.delegate = self;
    [self.addrSelectView bk_whenTapped:^{
        [self.navigationController pushViewController:addrMap animated:YES];
    }];
    
    if (0 == operateType) {
        self.navigationItem.title = @"发货地址";
        self.lbAddressName.text = @"请选择发货地点";
        [self.txtOrtherView setHidden:YES];
        [self.extraServiceSelect setHidden:YES];
    }
    else{
        self.navigationItem.title = @"收货地址";
        self.lbAddressName.text = @"请选择收货地点";
        [self.txtOrtherView setHidden:NO];
        self.txtOrtherView.delegate = self;
        self.txtOrtherView.placeholder = @"请填写运送到该地址相关的货物信息";
        
        // 额外服务
        bExtraService1 = NO;
        bExtraService2 = NO;
        bExtraService3 = NO;
        self.txtMonney.enabled = bExtraService1;
        [self.serviceView1 bk_whenTapped:^{
            bExtraService1 = !bExtraService1;
            self.txtMonney.enabled = bExtraService1;
            NSString *imgName = (bExtraService1)?@"chkBox_select":@"chkBox_noselect";
            [self.imgService1 setImage:[UIImage imageNamed:imgName]];
        }];
        [self.serviceView2 bk_whenTapped:^{
            bExtraService2 = !bExtraService2;
            NSString *imgName = (bExtraService2)?@"chkBox_select":@"chkBox_noselect";
            [self.imgService2 setImage:[UIImage imageNamed:imgName]];
        }];
        [self.serviceView3 bk_whenTapped:^{
            bExtraService3 = !bExtraService3;
            NSString *imgName = (bExtraService3)?@"chkBox_select":@"chkBox_noselect";
            [self.imgService3 setImage:[UIImage imageNamed:imgName]];
        }];
        
        [self.extraServiceSelect setHidden:NO];
        self.extraServiceView.frame = CGRectMake(SCREEN_WIDTH, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [self.view addSubview:self.extraServiceView];
        [self.extraServiceSelect bk_whenTapped:^{
            [self showExtraServiceView];
        }];
        
        UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExtraServiceExit)];
        [self.extraServiceView addGestureRecognizer:tapRegister];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardExit
{
    [self.txtAddressDetail resignFirstResponder];
    [self.txtRecvName resignFirstResponder];
    [self.txtPhoneNum resignFirstResponder];
    [self.txtOrtherView resignFirstResponder];
    if (self.contentView.top < 0) {
        [UIView animateWithDuration:0.3 animations:^{
            self.contentView.top = 0;
        }];
    }
}
// 代收款TextField的键盘推出
-(void)keyboardExtraServiceExit
{
    [self.txtMonney resignFirstResponder];
}

- (void)backup
{
    if (bExtraServiceBack){
        bExtraService1 = NO;
        bExtraService2 = NO;
        bExtraService3 = NO;
        [self hideExtraServiceView];
    }
    else{
        [self popViewController];
    }
}

#pragma mark - 额外服务选择
- (void)showExtraServiceView
{
    bExtraServiceBack = YES;
    self.navigationItem.title = @"额外服务";
    self.navigationItem.rightBarButtonItem = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.extraServiceView.left = 0;
    }];
}

- (void)hideExtraServiceView
{
    bExtraServiceBack = NO;
    [self.txtMonney resignFirstResponder];
    self.navigationItem.title = @"收货地址";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"常用地址" style:UIBarButtonItemStyleDone target:self action:@selector(addAddress)];
    [UIView animateWithDuration:0.2 animations:^{
        self.extraServiceView.left = SCREEN_WIDTH;
    }];
}
- (IBAction)btnExtraServiceClick
{
    [self hideExtraServiceView];
}

#pragma mark - UITextViewDelete
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.top -= 100;
    }];
}

#pragma mark - 添加常用地址
- (void)addAddress
{
    AddressListVController *addressList = [[AddressListVController alloc] init];
    addressList.delegate = self;
    [self keyboardExit];
    [self.navigationController pushViewController:addressList animated:YES];
}

// 地址代理方法
- (void) didSelectAddress:(AddressModel *)address
{
    self.address = address;
    self.lbAddressName.text = self.address.AddressName;
    self.txtAddressDetail.text = self.address.addressDetailName;
    self.txtRecvName.text = self.address.Consignee;
    self.txtPhoneNum.text = self.address.ContactPhone;
}
// 地址搜索代理方法
- (void) didSelectSearchAddress:(AddressModel *)address
{
    self.address = address;
    self.lbAddressName.text = self.address.AddressName;
    self.txtAddressDetail.text = self.address.addressDetailName;
    self.txtRecvName.text = @"";
    self.txtPhoneNum.text = @"";
}


#pragma mark - 地址确认
- (IBAction)btnOKClick
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
    // 保存为常用地址
    if (bCommonAddress) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:[Login sharedInstance].userID forKey:@"UserID"];
        [dict setObject:self.address.AddressName forKey:@"addressName"];
        //    [dict setObject:self.txtAddressDetail.text.trimString forKey:@"addressDetailName"];
        [dict setObject:self.txtRecvName.text.trimString forKey:@"consignee"];
        [dict setObject:self.txtPhoneNum.text.trimString forKey:@"phone"];
        [dict setObject:@(self.address.Longitude) forKey:@"longitude"];
        [dict setObject:@(self.address.Latitude) forKey:@"latitude"];
        [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KSaveCommonAddress andDictParam:dict requestSuccessed:^(id responseObject) {
            [self showResultThenHide:responseObject];
            [self addressConfirm];
        } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
            NSLog(@"%@",errorMessage);
            [self showResultThenHide:errorMessage];
            return ;
        }];
    }
    else{
        [self addressConfirm];
    }
}

// 地址代理响应
- (void)addressConfirm
{
    if (!(self.delegate && [self.delegate respondsToSelector:@selector(orderAddressSelected:)])){
        return ;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    // 收货地址
    [dict setObject:@(operateType) forKey:@"operateType"];
    if (operateType > 0) {
        OrderAddressModel *orderAddress = [[OrderAddressModel alloc] init];
        orderAddress.ID = self.address.ID;
        orderAddress.AddressName = self.address.AddressName;
        orderAddress.addressDetailName = self.address.addressDetailName;
        orderAddress.Latitude = self.address.Latitude;
        orderAddress.Longitude = self.address.Longitude;
        orderAddress.Consignee = self.address.Consignee;
        orderAddress.ContactPhone = self.address.ContactPhone;
        orderAddress.bHoldMonny = bExtraService1;
        orderAddress.bRecicleOrder = bExtraService2;
        orderAddress.bNeedMover = bExtraService3;
        orderAddress.ExtraMonny = self.txtMonney.text.trimString;
        orderAddress.aboutInfo = self.txtOrtherView.text.trimString;
        [dict setObject:orderAddress forKey:@"address"];
    }
    else{
        [dict setObject:self.address forKey:@"address"];
    }
    
    [self.delegate orderAddressSelected:dict];
    [self backup];
}

@end
