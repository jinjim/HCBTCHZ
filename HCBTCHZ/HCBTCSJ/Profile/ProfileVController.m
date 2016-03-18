//
//  ProfileVController.m
//  HCBTCSJ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "ProfileVController.h"
#import "ProfileHeaderView.h"

#define KHeightOfHeaderView       125
#define KWidthOfHeadImage         80

#define KButtonWidth              120
#define KButtonTop                100

@interface ProfileVController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
// HeaderView相关控件
@property (strong, nonatomic) ProfileHeaderView *tableHeaderView;
@property (strong, nonatomic) UIView *nologinView;
@property (strong, nonatomic) UIView *loginedView;
@property (strong, nonatomic) UIButton *btnLogin;
@property (strong, nonatomic) UIButton *btnRegister;

@property (strong, nonatomic) UIImageView *imgHead;


// table相关数据
@property (retain, nonatomic) NSArray *dataArray;
@property (retain, nonatomic) NSArray *imgArray;
@end

@implementation ProfileVController

static void *ObservationContext = &ObservationContext;
- (void)viewDidLoad {
    [super viewDidLoad];

//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.automaticallyAdjustsScrollViewInsets = false;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [[Login sharedInstance] addObserver:self forKeyPath:@"isLogined" options:NSKeyValueObservingOptionInitial context:&ObservationContext];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (context == ObservationContext) {
        [self updateHeaderView];
    }
    else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)updateHeaderView
{
    if ([Login sharedInstance].isLogined) {
        [self.tableHeaderView.noLoginView setHidden:YES];
        [self.tableHeaderView.loginedView setHidden:NO];
        NSString *name = ([Login sharedInstance].user.UserName.trimString.length == 0)?@"未填写你的名字":[Login sharedInstance].user.UserName.trimString;
        self.tableHeaderView.lbName.text = name;
        self.tableHeaderView.lbPhoneNum.text = [Login sharedInstance].user.ContactPhone;
    }
    else{
        [self.tableHeaderView.noLoginView setHidden:NO];
        [self.tableHeaderView.loginedView setHidden:YES];
    }
}

#pragma mark - 数据初始化
- (NSArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = @[@[@"钱包",@"报表"],@[@"关于我们",@"意见反馈",@"当前版本",@"设置"]];
    }
    return _dataArray;
}

-(NSArray *)imgArray
{
    if (_imgArray == nil) {
        _imgArray = @[@[@"wallet",@"reportTable"],@[@"about",@"opinion",@"update",@"setting"]];
    }
    return _imgArray;
}
-(ProfileHeaderView *)tableHeaderView
{
    if (_tableHeaderView == nil) {
        self.tableHeaderView = [[ProfileHeaderView alloc] init];
        self.tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, KHeightOfHeaderView);
        self.tableHeaderView.btnRegister.layer.borderWidth = 1.0;
        self.tableHeaderView.btnRegister.layer.cornerRadius = 5;
        self.tableHeaderView.btnRegister.layer.borderColor = KNavigationBarColor.CGColor;
        self.tableHeaderView.btnLogin.layer.borderWidth = 1.0;
        self.tableHeaderView.btnLogin.layer.cornerRadius = 5;
        self.tableHeaderView.btnLogin.layer.borderColor = KNavigationBarColor.CGColor;
        // 登录
        [self.tableHeaderView.btnLogin bk_whenTapped:^{
            [self pushViewController:@"UserLoginVController"];
        }];
        // 注册
        [self.tableHeaderView.btnRegister bk_whenTapped:^{
            [self pushViewController:@"RegisterVController"];
        }];
    }
    return _tableHeaderView;
}

#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"PROFILLCELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELLID];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.dataArray[indexPath.section][indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:self.imgArray[indexPath.section][indexPath.row]];
    
    return cell;
}


#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"%ld",(long)section);
    if (section == 0) {
        return self.tableHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return KHeightOfHeaderView;
    }
    return 1;
}

@end
