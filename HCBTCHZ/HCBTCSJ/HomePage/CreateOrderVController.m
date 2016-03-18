//
//  CreateOrderVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/4.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "CreateOrderVController.h"
#import "OrderInfoVController.h"

#define KRemarkHeight      120

@interface CreateOrderVController ()<OrderAddressDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger orderType;
    NSInteger payType;
    NSString *selectDate;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSArray *imgArray;
@property (strong, nonatomic) NSMutableArray *addressArray;  // 地址Array

@property (strong, nonatomic) UIButton *btnNewAddr;
@property (strong, nonatomic) UITextView *remarkView;

@property (strong, nonatomic) IBOutlet UIDatePicker *pckDateTime;
@property (strong, nonatomic) UIView *dateMaskView;

@property (strong, nonatomic) IBOutlet UIView *paywayView;
@property (weak, nonatomic) IBOutlet UIView *payOnlineView;
@property (weak, nonatomic) IBOutlet UIView *payOutLineView;
@property (strong, nonatomic) UIView *paywayMaskView;
@end

@implementation CreateOrderVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    orderType = [self.params[@"type"] integerValue];
    self.navigationItem.title = (orderType == 0)?@"整车下单":@"零担下单";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnOK)];
    
    selectDate = [TimeUtils timeStringFromDate:self.pckDateTime.date withFormat:DateFormat9];
    [self pickerViewInit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDateTimePicker)];
    [self.dateMaskView addGestureRecognizer:tapRegister];
    UITapGestureRecognizer *tapRegister1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePayway)];
    [self.paywayMaskView addGestureRecognizer:tapRegister1];
    // 添加键盘退出功能
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapGesture];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 选择视图的初始化
- (void) pickerViewInit
{
    // 时间背景View
    self.dateMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.dateMaskView.alpha = 1;
    self.pckDateTime.alpha = 1;
    self.pckDateTime.backgroundColor = [UIColor whiteColor];
    self.dateMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.pckDateTime.top = SCREEN_HEIGHT - self.pckDateTime.height;
    self.pckDateTime.width = SCREEN_WIDTH;
    [self.dateMaskView addSubview:self.pckDateTime];
    [self.view addSubview:self.dateMaskView];
    
    // 支付方式选择视图创建
    payType = -1;
    self.paywayMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.paywayMaskView.alpha = 1;
    self.paywayView.alpha = 1;
    self.paywayView.backgroundColor = [UIColor whiteColor];
    self.paywayMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.paywayView.frame = CGRectMake(0, SCREEN_HEIGHT-134, SCREEN_WIDTH, 134);
    [self.payOnlineView bk_whenTapped:^{
        NSLog(@"线上支付");
        payType = 0;
        [self hidePayway];
    }];
    [self.payOutLineView bk_whenTapped:^{
        NSLog(@"线下支付");
        payType = 1;
        [self hidePayway];
    }];
    [self.paywayMaskView addSubview:self.paywayView];
    [self.view addSubview:self.paywayMaskView];
}

#pragma mark - 数据创建
- (NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@[@"order_putaway",@"order_sendout"],@[@"icon_time",@"icon_car"],@[@"icon_money",@"icon_pay",@"icon_order"]];
    }
    return _imgArray;
}

- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        NSString *str = (orderType==1)?@"货物描述":@"需要车型";
        _dataArray = @[@[@"装货时间",str],
                      @[@"费用",@"支付方式",@"订单指派"]];
    }
    return _dataArray;
}

-(NSMutableArray *)addressArray
{
    if (_addressArray == nil) {
        _addressArray = [[NSMutableArray alloc] init];
        OrderAddressModel *orderAddress = [[OrderAddressModel alloc] init];
        orderAddress.AddressName =  @"选择收货地址";
        AddressModel *address = [[AddressModel alloc] init];
        address.AddressName =  @"选择发货地址";
        [_addressArray addObjectsFromArray:@[address, orderAddress]];
    }
    return _addressArray;
}

#pragma mark - 日期时间选择
- (void)showDateTimePicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dateMaskView.top = 0;
    }];
}

- (void)hideDateTimePicker
{
    [UIView animateWithDuration:0.3 animations:^{
        self.dateMaskView.top = SCREEN_HEIGHT;
        selectDate = [TimeUtils timeStringFromDate:self.pckDateTime.date withFormat:DateFormat9];
        NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 支付方式选择
- (void)showPayway
{
    [UIView animateWithDuration:0.3 animations:^{
        self.paywayMaskView.top = 0;
    }];
}

- (void)hidePayway
{
    [UIView animateWithDuration:0.3 animations:^{
        self.paywayMaskView.top = SCREEN_HEIGHT;
        NSIndexPath *path = [NSIndexPath indexPathForItem:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

#pragma mark - 确定下单
- (void)btnOK
{
}

#pragma mark - tableDataSource相关
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (section == 0)?self.addressArray.count:[self.dataArray[section-1] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"OrderCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1  reuseIdentifier:CellID];
    }
    
    if(indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            AddressModel *address = self.addressArray[indexPath.row];
            cell.textLabel.text = address.AddressName;
        }
        else{
            OrderAddressModel *orderAddress  = self.addressArray[indexPath.row];
            cell.textLabel.text = orderAddress.AddressName;
        }
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"";
    }
    else if (indexPath.section==1 && indexPath.row==0){
        cell.detailTextLabel.text = selectDate;
        cell.textLabel.text = self.dataArray[indexPath.section-1][indexPath.row];
    }
    else if (indexPath.section==2 && indexPath.row==1){
        cell.textLabel.text = self.dataArray[indexPath.section-1][indexPath.row];
        if (payType == -1) {
            cell.detailTextLabel.text = @"";
        }
        else{
            cell.detailTextLabel.text = (payType == 0)?@"在线支付":@"线下支付";
        }
    }
    else
    {
        cell.textLabel.text = self.dataArray[indexPath.section-1][indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    NSString *imgName = (indexPath.section == 0 && indexPath.row > 0)?self.imgArray[indexPath.section][1]:self.imgArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imgName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.textColor = [UIColor blackColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 0){
        return 40;
    }
    else if (section == self.dataArray.count){
        return KRemarkHeight;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        self.btnNewAddr = [[UIButton alloc] initWithFrame:CGRectMake(12, 5, 120, 30)];
        self.btnNewAddr.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.btnNewAddr.layer.borderWidth = 1.0f;
        self.btnNewAddr.layer.cornerRadius = 5;
        [self.btnNewAddr setTitle:@"+ 添加收货地址" forState:UIControlStateNormal];
        [self.btnNewAddr setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.btnNewAddr.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btnNewAddr bk_whenTapped:^{
            OrderAddressModel *orderAddress = [[OrderAddressModel alloc] init];
            orderAddress.AddressName =  @"选择收货地址";
            [self.addressArray addObject:orderAddress];
            [self.tableView reloadData];
        }];
        [view addSubview:self.btnNewAddr];
        
        CGRect lbRect = CGRectMake(142, 5, SCREEN_WIDTH-152, 30);
        UILabel *lbTip = [[UILabel alloc] initWithFrame:lbRect];
        lbTip.text = @"收货地址左滑删除";
        lbTip.textColor = [UIColor lightGrayColor];
        lbTip.font = [UIFont systemFontOfSize:14];
        [view addSubview:lbTip];
        return view;
    }
    else if (section == self.dataArray.count){
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, KRemarkHeight-20);
        UIView *view = [[UIView alloc] initWithFrame:rect];
        CGRect markRect = CGRectMake(8, 8, SCREEN_WIDTH-16, KRemarkHeight-16);
        self.remarkView = [[UITextView alloc] initWithFrame:markRect];
        self.remarkView.font = [UIFont systemFontOfSize:13];
        self.remarkView.placeholder = @"备注：你可以在这里告诉司机你的货物情况或者注意事项，例如：生鲜、500KG";
        [view addSubview:self.remarkView];
        return view;
    }
    else{
        return nil;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row>0 && self.addressArray.count>2) {
        return YES;
    }
    return NO;
}

/*改变删除按钮的title*/
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

/*删除用到的函数*/
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        [self.addressArray removeObjectAtIndex:indexPath.row];   //删除数组里的数据
        [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];  //删除对应数据的cell
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        OrderInfoVController *orderInfo = [[OrderInfoVController alloc] init];
        orderInfo.params = @{@"type":@(indexPath.row)};
        orderInfo.delegate = self;
        [self.navigationController pushViewController:orderInfo animated:YES];
    }
    else if (indexPath.section == 1) {
        if(indexPath.row == 0) {
            [self showDateTimePicker];
        }
        else{
            // 0-费用选择；1-车型选择；2-订单指派；3-货物描述
            NSString *str = (orderType==1)?@"3":@"1";
            NSDictionary *dict = @{@"type":str};
            [self pushViewController:@"OrderSelectVController" withParams:dict];
        }
            
    }
    else if (indexPath.section == 2){
        
        if(indexPath.row == 1) {
            [self showPayway];
        }
        else{
            // 0-费用选择；1-车型选择；2-订单指派；3-货物描述
            NSDictionary *dict = @{@"type":@(indexPath.row)};
            [self pushViewController:@"OrderSelectVController" withParams:dict];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 键盘处理方法
-(void)hideKeyBoard
{
    [self.remarkView resignFirstResponder];
}

- (void)keyboardShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"height: %f",kSize.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.top -= (kSize.height);
    }];
}
- (void)keyboardHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    NSLog(@"height: %f",kSize.height);
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.top += (kSize.height);
    }];
}

#pragma mark - 代理方法
// 订单地址代理方法
- (void)orderAddressSelected:(NSDictionary *)dict
{
    NSInteger opType = [dict[@"operateType"] integerValue];
    if (opType == 0) {
        [self.addressArray removeObjectAtIndex:0];
        [self.addressArray insertObject:dict[@"address"] atIndex:0];
    }
    else{
        [self.addressArray removeObjectAtIndex:opType];
        [self.addressArray insertObject:dict[@"address"] atIndex:opType];
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:opType inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

@end
