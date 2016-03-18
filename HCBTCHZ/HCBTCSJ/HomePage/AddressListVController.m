//
//  AddressListVController.m
//  HCBTCHZ
//
//  Created by itte on 16/3/4.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "AddressListVController.h"
#import "AdressListTableCell.h"
#import <MJRefresh.h>

@interface AddressListVController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation AddressListVController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewAddress)];
    self.navigationItem.title = @"常用地址";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self loadNetworkData];
    }];
    [self.tableView.mj_header beginRefreshing];
    [self.tableView registerNib:[UINib nibWithNibName:@"AdressListTableCell" bundle:nil] forCellReuseIdentifier:@"AddressListCellID"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addNewAddress
{
    NSDictionary *dict = @{@"type":@"0"};
    [self pushViewController:@"AddressEditVController" withParams:dict];
}

- (NSMutableArray *)dataArray
{
    if(_dataArray == nil){
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

#pragma mark - 获取网络数据
- (void)loadNetworkData
{
    if (![Login sharedInstance].isLogined) {
        [self.tableView.mj_header endRefreshing];
        return ;
    }
    NSDictionary *dictParam = @{@"UserId":[Login sharedInstance].userID};
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KGetCommonAddress andDictParam:dictParam requestSuccessed:^(id responseObject) {
        NSArray *data = [AddressModel mj_objectArrayWithKeyValuesArray:responseObject];
        if (data.count > 0) {
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:data];
            [self.tableView reloadData];
        }
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        
    }];
    [self.tableView.mj_header endRefreshing];
}

#pragma mark - tableViewDataSource方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdressListTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCellID"];
    if (cell == nil) {
        cell = [[AdressListTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddressListCellID"];
    }
    AddressModel *address = self.dataArray[indexPath.row];
    cell.lbAddrName.text = address.AddressName;
    cell.lbAddrSubName.text = address.addressDetailName;
    cell.lbUserName.text = address.Consignee;
    cell.lbPhoneNum.text = address.ContactPhone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}
#pragma mark - tableViewDelegate方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectAddress:)]) {
        AddressModel *address = self.dataArray[indexPath.row];
        [self.delegate didSelectAddress:address];
        [self backup];
    }
    else{
        AddressModel *address = self.dataArray[indexPath.row];
        NSDictionary *dict = @{@"type":@"1",@"address":address};
        [self pushViewController:@"AddressEditVController" withParams:dict];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
        AddressModel *address = self.dataArray[indexPath.row];
        NSDictionary *dictParam = @{@"addressId":address.ID};
        [[AFNetworkManager sharedInstance] AFNHttpRequestWithAPI:KDeleteCommonAddress andDictParam:dictParam requestSuccessed:^(id responseObject) {
            [self showResultThenHide:@"删除地址成功！"];
            //删除数组里的数据
            [self.dataArray removeObjectAtIndex:indexPath.row];
            //删除对应数据的cell
            [tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
        } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
            
        }];
        
    }
}
@end
