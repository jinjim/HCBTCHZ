//
//  AddDriverVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/9.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "AddDriverVController.h"
#import "DriverTableCell.h"

@interface AddDriverVController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *txtSearchView;
@property (strong, nonatomic) UIImageView *imgSearch;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation AddDriverVController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if([self.params[@"type"] integerValue] == 0){
        self.navigationItem.titleView = self.txtSearchView;
    }
    else{
        self.navigationItem.title = @"历史司机";
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    UITapGestureRecognizer *tapRegister = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardExit)];
    [self.view addGestureRecognizer:tapRegister];

    [self.tableView registerNib:[UINib nibWithNibName:@"DriverTableCell" bundle:nil] forCellReuseIdentifier:@"DriverTableCell"];
}

- (void)keyboardExit
{
    [self.txtSearchView resignFirstResponder];
}

-(UITextField *)txtSearchView
{
    if (_txtSearchView == nil) {
        CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH-50, 30);
        _txtSearchView = [[UITextField alloc] initWithFrame:rect];
        _txtSearchView.font = [UIFont systemFontOfSize:13];
        _txtSearchView.placeholder = @"请输入车牌号和手机号进行搜索";
        _txtSearchView.backgroundColor = [UIColor whiteColor];
        _imgSearch = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_seach"]];
        _txtSearchView.rightView = _imgSearch;
        _txtSearchView.rightViewMode = UITextFieldViewModeAlways;
        _txtSearchView.rightView.userInteractionEnabled = YES;
        _txtSearchView.returnKeyType = UIReturnKeySearch;
        _txtSearchView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _txtSearchView.delegate = self;
        [_imgSearch bk_whenTapped:^{
            NSLog(@"开始搜索");
            [self keyboardExit];
            [self loadNetworkData];
        }];
    }
    return _txtSearchView;
}
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark - 网络请求
- (void) loadNetworkData
{
    NSString *keyWord = self.txtSearchView.text.trimString;
    if (keyWord.isEmpty) {
        return ;
    }
    NSDictionary *dictParam = @{@"Phone":keyWord};
    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KSearchDriver andDictParam:dictParam requestSuccessed:^(id responseObject) {
        NSArray *data = [DriverModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        [self.tableView reloadData];
        [self hideHUDLoading];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
}

#pragma mark - 添加常用司机
- (void)addDriverWithID:(NSString *)driverID
{
    NSDictionary *dictParam = @{@"UserID":[Login sharedInstance].userID,@"vehicleId":driverID};
    [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KAddDriver andDictParam:dictParam requestSuccessed:^(id responseObject) {
        [self showResultThenHide:@"添加成功"];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:@"添加失败"];
    }];
}

#pragma mark - tableviewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"DriverTableCell";
    DriverTableCell *cell = (DriverTableCell *)[tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[DriverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CELLID];
    }
    DriverModel *driver = self.dataArray[indexPath.row];
    cell.lbCarNum.text = driver.PlateNumber;
    cell.lbCarType.text = driver.VehicleTypeName;
    cell.lbDriverName.text = driver.DriverName;
    cell.lbDriverPhone.text = driver.DriverUserName;
    [cell.btnAdd bk_whenTapped:^{
        [self addDriverWithID:driver.ID];
    }];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

#pragma mark - UItextfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"开始搜索");
    [self keyboardExit];
    [self loadNetworkData];
    return YES;
}
@end
