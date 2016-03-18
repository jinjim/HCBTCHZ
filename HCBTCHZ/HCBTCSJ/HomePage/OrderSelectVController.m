//
//  OrderSelectVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/7.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "OrderSelectVController.h"
#import "GoodsDesVCtroller.h"
#import "OrderDriverTableCell.h"
#import <MJRefresh.h>

@interface OrderSelectVController ()<GoodsDescriptionDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSInteger operateType;
    
    NSInteger priceType;     // 报价类型
    NSInteger orderSendType; // 订单指派类型
    BOOL bAllSelect;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// 信息发送
@property (strong, nonatomic) IBOutlet UIView *msgToDriverView;
// 发送给所有司机
@property (weak, nonatomic) IBOutlet UIView *msgToAllDriver;
// 发送给常用司机
@property (weak, nonatomic) IBOutlet UIView *msgToSomeDriver;
// 全选按钮
@property (weak, nonatomic) IBOutlet UIView *allSelectView;
@property (weak, nonatomic) IBOutlet UIImageView *imgArllDriver;
@property (weak, nonatomic) IBOutlet UIImageView *imgSomeDriver;
@property (weak, nonatomic) IBOutlet UIImageView *imgAllSelect;

// 货物报价
@property (strong, nonatomic) IBOutlet UIView *getPriceView;
@property (weak, nonatomic) IBOutlet UIImageView *imgMySelect;
// 货主报价
@property (weak, nonatomic) IBOutlet UIView *myPriceView;
@property (weak, nonatomic) IBOutlet UIImageView *imgDriverSelect;
// 司机报价
@property (weak, nonatomic) IBOutlet UIView *driverPriceView;
@property (weak, nonatomic) IBOutlet UITextField *txtPrice;


// 货物描述
@property (strong, nonatomic) IBOutlet UIView *goodsDescView;
@property (weak, nonatomic) IBOutlet UIView *goodsNameView;
@property (weak, nonatomic) IBOutlet UILabel *lbGoodsName;
@property (weak, nonatomic) IBOutlet UITextField *txtGoodsVolume;
@property (weak, nonatomic) IBOutlet UITextField *txtGoodsWeight;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation OrderSelectVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0-费用选择；1-车型选择；2-订单指派；3-货物描述
    NSArray *title = @[@"费用",@"车型选择",@"订单指派",@"货物描述"];
    operateType = [self.params[@"type"] integerValue];
    self.navigationItem.title = title[operateType];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnOK)];
    
    priceType = 0;     // 货主报价
    orderSendType = 0; // 发给所有司机
    // 视图配置
    [self viewInitByType:operateType];
    
    // 添加键盘退出功能
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 视图初始化
- (void)viewInitByType:(NSInteger)type
{
    // 0-费用选择；1-车型选择；2-订单指派；3-货物描述
    if (type == 0) {
        self.getPriceView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 104);
        self.tableView.tableHeaderView = self.getPriceView;
        
        [self.myPriceView bk_whenTapped:^{
            [self.imgMySelect setImage:[UIImage imageNamed:@"chose"]];
            [self.imgDriverSelect setImage:[UIImage imageNamed:@"chose_pre"]];
            self.txtPrice.enabled = YES;
            priceType = 0;   // 货主报价
        }];
        
        [self.driverPriceView bk_whenTapped:^{
            [self.imgMySelect setImage:[UIImage imageNamed:@"chose_pre"]];
            [self.imgDriverSelect setImage:[UIImage imageNamed:@"chose"]];
            self.txtPrice.enabled = NO;
            priceType = 1;   // 司机报价
        }];
    }
    else if (type == 1){
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    else if (type == 2){
        self.msgToDriverView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 148);
        self.tableView.tableHeaderView = self.msgToDriverView;
        bAllSelect = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self loadNetWorkData];
        [self.tableView registerNib:[UINib nibWithNibName:@"OrderDriverTableCell" bundle:nil] forCellReuseIdentifier:@"OrderDriverTableCell"];
        [self.msgToAllDriver bk_whenTapped:^{
            [self.imgArllDriver setImage:[UIImage imageNamed:@"chose"]];
            [self.imgSomeDriver setImage:[UIImage imageNamed:@"chose_pre"]];
            [self.imgAllSelect setImage:[UIImage imageNamed:@"chkBox_noselect"]];
            self.allSelectView.userInteractionEnabled = NO;
            orderSendType = 0; // 发给所有司机
        }];
        
        [self.msgToSomeDriver bk_whenTapped:^{
            [self.imgArllDriver setImage:[UIImage imageNamed:@"chose_pre"]];
            [self.imgSomeDriver setImage:[UIImage imageNamed:@"chose"]];
            self.allSelectView.userInteractionEnabled = YES;
            orderSendType = 1; // 发给常用司机
        }];
        
        [self.allSelectView bk_whenTapped:^{
            bAllSelect = !bAllSelect;
            NSString *img = (bAllSelect)?@"chkBox_select":@"chkBox_noselect";
            [self.imgAllSelect setImage:[UIImage imageNamed:img]];
            for (OrderDriverModel *orderDriver in self.dataArray) {
                orderDriver.bSelectStatus = bAllSelect;
            }
            [self.tableView reloadData];
        }];
    }
    else if (type == 3){
        self.goodsDescView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 144);
        self.tableView.tableHeaderView = self.goodsDescView;
        
        [self.goodsNameView bk_whenTapped:^{
            GoodsDesVCtroller *goodsDes = [[GoodsDesVCtroller alloc] init];
            goodsDes.delegate = self;
            [self.navigationController pushViewController:goodsDes animated:YES];
        }];
    }
}

- (void)hideKeyBoard
{
    [self.txtGoodsVolume resignFirstResponder];
    [self.txtGoodsWeight resignFirstResponder];
    [self.txtPrice resignFirstResponder];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - 获取网络数据
- (void)loadNetWorkData
{
    NSDictionary *dictParam = @{@"UserID":[Login sharedInstance].userID};
    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KGetCommonDriver andDictParam:dictParam requestSuccessed:^(id responseObject) {
        NSArray *data = [OrderDriverModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        for (OrderDriverModel *orderDriver in self.dataArray) {
            orderDriver.bSelectStatus = NO;
        }
        [self.tableView reloadData];
        [self hideHUDLoading];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
}


#pragma mark - 输入完成返回
- (void)btnOK
{
    // 0-费用选择；1-车型选择；2-订单指派；3-货物描述
    if (operateType == 0) {
        if(priceType == 0 && self.txtPrice.text.trimString.length == 0){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入你的报价金额" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            return ;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[@(priceType),self.txtPrice.text.trimString] forKeys:@[@"priceType",@"priceGive"]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsPriceConfirm:)]) {
            [self.delegate goodsPriceConfirm:dict];
            [self backup];
        }
    }
    else if (operateType == 1){
        
    }
    else if (operateType == 2){
        
    }
    else if (operateType == 3){
        if (self.lbGoodsName.text.trimString.length == 0) {
            [self showResultThenHide:@"请选择货物名称"];
            return ;
        }
        if (self.txtGoodsVolume.text.trimString.length == 0) {
            [self showResultThenHide:@"请输入货物体积"];
            return ;
        }
        if (self.txtGoodsWeight.text.trimString.length == 0) {
            [self showResultThenHide:@"请输入货物重量"];
            return ;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[self.lbGoodsName.text.trimString,self.txtGoodsVolume.text.trimString,self.txtGoodsWeight.text.trimString] forKeys:@[@"goodsName",@"goodsVolume",@"goodsWeight"]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsDescriptionSelect:)]) {
            [self.delegate goodsDescriptionSelect:dict];
        }
    }
}


#pragma mark - 代理方法
- (void)selectedItem:(NSString *)desc
{
    self.lbGoodsName.text = desc;
}


#pragma mark - tableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"OrderDriverTableCell";
    OrderDriverTableCell *cell = (OrderDriverTableCell *)[tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[OrderDriverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    OrderDriverModel *driver = self.dataArray[indexPath.row];
    cell.lbCarNum.text = driver.PlateNumber;
    cell.lbCarType.text = driver.VehicleTypeName;
    cell.lbDriverName.text = driver.DriverName;
    NSString *img = (driver.bSelectStatus)?@"chkBox_select":@"chkBox_noselect";
    cell.imgStatus.image = [UIImage imageNamed:img];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDriverModel *driver = self.dataArray[indexPath.row];
    driver.bSelectStatus = !driver.bSelectStatus;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
@end
