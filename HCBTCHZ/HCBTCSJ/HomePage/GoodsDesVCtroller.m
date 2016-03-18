//
//  GoodsDesVCtroller.m
//  HCBTCHZ
//
//  Created by itte on 16/3/8.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "GoodsDesVCtroller.h"
#import "GoodsDescCell.h"

@interface GoodsDesVCtroller ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSInteger itemSelect;
    NSString *itemDesc;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) UITextField *txtInput;
@end

@implementation GoodsDesVCtroller

- (void)viewDidLoad {
    [super viewDidLoad];
    itemSelect = -1;
    itemDesc = @"";
    self.navigationItem.titleView = self.txtInput;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(btnOK)];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodsDescCell" bundle:nil]forCellWithReuseIdentifier:@"CollectionCELL"];
    
    [self LoadNetworkData];
    
    // 添加键盘退出功能
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITextField *)txtInput
{
    if (_txtInput == nil) {
        CGRect rect = CGRectMake(0, 0, 300, 30);
        _txtInput = [[UITextField alloc] initWithFrame:rect];
        _txtInput.placeholder = @"自定义";
        _txtInput.backgroundColor = [UIColor whiteColor];
        _txtInput.borderStyle = UITextBorderStyleRoundedRect;
    }
    return _txtInput;
}

- (void)btnOK
{
    if (self.txtInput.text.trimString.length==0 && itemSelect<0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择货物名称" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
    }

    NSString *desc = (self.txtInput.text.trimString.length > 0)?self.txtInput.text.trimString:itemDesc;
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedItem:)]) {
        [self.delegate selectedItem:desc];
    }
    [self backup];
}

- (void)hideKeyBoard
{
    [self.txtInput resignFirstResponder];
}

#pragma mark - 获取网络数据
- (void)LoadNetworkData
{
    [[AFNetworkManager sharedInstance] AFNHttpGetWithAPI:KGetGoodsType andDictParam:nil requestSuccessed:^(id responseObject) {
        NSArray *data = [GoodsTypeModel mj_objectArrayWithKeyValuesArray:responseObject];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:data];
        [self.collectionView reloadData];
    } requestFailure:^(NSInteger errorCode, NSString *errorMessage) {
        [self showResultThenHide:@"获取网络失败"];
    }];
}


#pragma mark - collectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CELLID = @"CollectionCELL";
    GoodsDescCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    GoodsTypeModel *goods = self.dataArray[indexPath.row];
    [cell.btnTitle setTitle:goods.Type forState:UIControlStateNormal];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsDescCell *cellSelect = (GoodsDescCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cellSelect.btnTitle.backgroundColor = KNavigationBarColor;
    self.txtInput.text = @"";
    itemDesc = cellSelect.btnTitle.titleLabel.text;
    if (itemSelect == -1) {
        itemSelect = indexPath.item;
        return;
    }
    
    NSIndexPath *index = [NSIndexPath indexPathForItem:itemSelect inSection:0];
    [collectionView deselectItemAtIndexPath:index animated:YES];
    itemSelect = indexPath.item;
    GoodsDescCell *cell = (GoodsDescCell *)[collectionView cellForItemAtIndexPath:index];
    cell.btnTitle.backgroundColor = [UIColor clearColor];
}

@end
