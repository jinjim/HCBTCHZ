//
//  MyDriverVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/9.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "MyDriverVController.h"
#import "DriverTableCell.h"
#import <MJRefresh.h>

#define KMenuTop   64

@interface MyDriverVController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *addDriver;
@property (weak, nonatomic) IBOutlet UIView *historyDriver;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation MyDriverVController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"常用司机";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(btnMemuClick)];
    // 常用司机添加初始化
    [self menuViewInit];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DriverTableCell" bundle:nil] forCellReuseIdentifier:@"DriverTableCell"];
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNetWorkData)];
    [self.tableView.mj_header beginRefreshing];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - 添加常用司机
- (void) menuViewInit
{
    self.menuView.frame = CGRectMake(SCREEN_WIDTH, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-KMenuTop);
    [self.menuView bk_whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.top = -SCREEN_HEIGHT;
            self.menuView.left = SCREEN_WIDTH;
        }];
    }];
    [self.addDriver bk_whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.top = -SCREEN_HEIGHT;
            self.menuView.left = SCREEN_WIDTH;
        }];
        // 添加常用司机
        [self pushViewController:@"AddDriverVController" withParams:@{@"type":@"0"}];
    }];
    [self.historyDriver bk_whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.top = -SCREEN_HEIGHT;
            self.menuView.left = SCREEN_WIDTH;
        }];
        // 添加历史司机
        [self pushViewController:@"AddDriverVController" withParams:@{@"type":@"1"}];
    }];
    [self.view addSubview:self.menuView];
}

- (void)btnMemuClick
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.top = KMenuTop;
        self.menuView.left = 0;
    }];
}

#pragma mark - 获取网络数据
- (void)loadNetWorkData
{
    NSDictionary *dictParam = @{@"UserID":[Login sharedInstance].userID};
    [self showHUDLoading];
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KGetCommonDriver andDictParam:dictParam requestSuccessed:^(id responseObject) {
        NSArray *data = [DriverModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        [self.tableView reloadData];
        [self hideHUDLoading];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self hideHUDLoading];
    }];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - tableViewDataSource
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
    [cell.btnAdd setHidden:YES];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
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
        DriverModel *driver = self.dataArray[indexPath.row];
        NSDictionary *dictParam = @{@"driverId":driver.ID};
        [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KDeleteDriver andDictParam:dictParam requestSuccessed:^(id responseObject) {
            [self showResultThenHide:@"删除成功！"];
            //删除数组里的数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
            //删除对应数据的cell
            [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
            [self showResultThenHide:@"删除失败！"];
        }];
        
    }
}
@end
