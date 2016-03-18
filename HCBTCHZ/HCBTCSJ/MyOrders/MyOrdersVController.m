//
//  MyOrdersVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "MyOrdersVController.h"
#import <MJRefresh.h>
#import "OrderMenuView.h"
#import "MyOrderTableCell.h"

#define KMenuTop   64

static NSString *CellTableIdentifier = @"MyOrderTableCell";

@interface MyOrdersVController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger menuType;
    UIColor *defualtColor;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *sepGoingView;
@property (weak, nonatomic) IBOutlet UIView *sepFinishView;

@property (weak, nonatomic) IBOutlet UIButton *btnGoing;
@property (weak, nonatomic) IBOutlet UIButton *btnFinish;
@property (strong, nonatomic) NSMutableArray *menuArray;

// 菜单控件
@property (weak, nonatomic) OrderMenuView *menuView;

@end

@implementation MyOrdersVController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [self loadNetworkData];
    }];
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
        [self loadNetworkData];
    }];
    
    [self btnChangeClick:self.btnGoing];
    [self menuInit];
    
    //从xib中加载cell
    UINib *nib = [UINib nibWithNibName:@"MyOrderTableCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
    self.tableView.delegate = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 状态切换
- (IBAction)btnChangeClick:(UIButton *)sender
{
    if(sender.tag == 500){
        self.sepGoingView.backgroundColor = [UIColor orangeColor];
        self.sepFinishView.backgroundColor = [UIColor lightGrayColor];
    }
    else{
        self.sepGoingView.backgroundColor = [UIColor lightGrayColor];
        self.sepFinishView.backgroundColor = [UIColor orangeColor];
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 下拉刷新操作
- (void)loadNetworkData
{
    
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - 菜单选择
- (void)menuInit
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu"] style:UIBarButtonItemStyleDone target:self action:@selector(showMemuView)];
    
    self.menuArray = [NSMutableArray array];
    self.menuView = (OrderMenuView *)[[OrderMenuView alloc] init];
    self.menuView.frame = CGRectMake(-SCREEN_WIDTH, -SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-KMenuTop);
    self.menuView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.7];
    [self.view addSubview:self.menuView];
    [self.menuView bk_whenTapped:^{
        [UIView animateWithDuration:0.2 animations:^{
            self.menuView.top = -SCREEN_HEIGHT;
            self.menuView.left = -SCREEN_WIDTH;
        }];
    }];
    
    defualtColor = self.menuView.lbAll.textColor;
    [self.menuArray addObject:self.menuView.lbAll];
    [self.menuArray addObject:self.menuView.lbCallCar];
    [self.menuArray addObject:self.menuView.lbWaiting];
    [self.menuArray addObject:self.menuView.lbTransport];
    [self.menuArray addObject:self.menuView.lbWaitingConfirm];
    [self selectMemu:0];
    [self.menuView.allView bk_whenTapped:^{
        menuType = 0;
        [self selectMemu:menuType];
    }];
    [self.menuView.callCarView bk_whenTapped:^{
        menuType = 1;
        [self selectMemu:menuType];
    }];
    [self.menuView.waitingView bk_whenTapped:^{
        menuType = 2;
        [self selectMemu:menuType];
    }];
    [self.menuView.transportView bk_whenTapped:^{
        menuType = 3;
        [self selectMemu:menuType];
    }];
    [self.menuView.waitingConfirmView bk_whenTapped:^{
        menuType = 4;
        [self selectMemu:menuType];
    }];
}

- (void)selectMemu:(NSInteger)index
{
    for (int i=0; i<self.menuArray.count; i++) {
        UILabel *label = self.menuArray[i];
        if (i == index) {
            [label setTextColor:KNavigationBarColor];
        }
        else{
            [label setTextColor:defualtColor];
        }
    }
    [self hideMemuView];
}

- (void)showMemuView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.top = KMenuTop;
        self.menuView.left = 0;
    }];
}

- (void)hideMemuView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.top = -SCREEN_HEIGHT;
        self.menuView.left = -SCREEN_WIDTH;
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyOrderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (cell == nil) {
        cell = [[MyOrderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 116;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self pushViewController:@"BillVController" withParams:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
