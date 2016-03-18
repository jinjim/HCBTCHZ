//
//  AddrMapVController.m
//  HCBTCHZ
//
//  Created by itte on 3/3/16.
//  Copyright © 2016 itte. All rights reserved.
//

#import "AddrMapVController.h"
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import <CoreLocation/CoreLocation.h>

#define KSearchViewHeight  30
#define KTipViewHeight     320

@interface AddrMapVController ()<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationManager *locationManager;
    MKMapView *_mapView;
}
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) UITextField *txtSearch;
@property (strong, nonatomic) NSMutableArray *dataArray;

// 当进行搜索时，弹出的一些信息
@property (strong, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AddrMapVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startMap];
    [self addressSearch];
    self.tipView.frame = CGRectMake(1, SCREEN_HEIGHT, SCREEN_WIDTH-2, KTipViewHeight);
    [self.view addSubview:self.tipView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navig_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backup)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.dataArray = [[NSMutableArray alloc] init];
}

#pragma mark 添加地图控件
- (void) startMap
{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    //请求定位服务
    locationManager=[[CLLocationManager alloc]init];
    if(![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse){
        [locationManager requestWhenInUseAuthorization];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType = MKMapTypeStandard;
    
    //添加大头针
    // [self addAnnotation];
    
}
#pragma mark 添加大头针
- (void)addAnnotation
{
    CLLocationCoordinate2D location=CLLocationCoordinate2DMake(39.95, 116.35);
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"";
    annotation1.subtitle=@"";
    annotation1.coordinate=location;
    [_mapView addAnnotation:annotation1];
}

- (void)addressSearch
{
    self.txtSearch = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-50, KSearchViewHeight)];
    self.txtSearch.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_seach"]];
    self.txtSearch.leftViewMode = UITextFieldViewModeAlways;
    self.txtSearch.alpha = 1.0;
    self.txtSearch.backgroundColor = [UIColor whiteColor];
    self.txtSearch.placeholder = @"请输入收货地址";
    [self.txtSearch addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.navigationItem.titleView = self.txtSearch;
}

#pragma mark - 文本框代理方法
- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *address = textField.text;
    [self getSomeAddressByInfo:address];
    [self tipViewInit];
}

- (void)getSomeAddressByInfo:(NSString *)info
{
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = info;
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (self.dataArray.count > 0) {
            [self.dataArray removeAllObjects];
        }
        
        for (int i=0; (i<50)&&(i<response.mapItems.count); i++) {
            [self.dataArray addObject:response.mapItems[i]];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - 弹出框初始化
- (void)tipViewInit
{
    [UIView animateWithDuration:0.5 animations:^{
        self.tipView.top = 65;
    }];
    
}

#pragma mark - tableDelegate方法
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCELL = @"CEEID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCELL];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDCELL];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    MKMapItem *item = self.dataArray[indexPath.row];
    NSLog(@"纬度-%f",item.placemark.coordinate.latitude);
    NSLog(@"经度-%f",item.placemark.coordinate.longitude);
    cell.textLabel.text = item.name;
    cell.detailTextLabel.text = item.placemark.addressDictionary[@"FormattedAddressLines"][0];
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.txtSearch resignFirstResponder];
    [UIView animateWithDuration:0.1 animations:^{
        self.tipView.top = SCREEN_HEIGHT;
    }];
 
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectSearchAddress:)]) {
        MKMapItem *item = self.dataArray[indexPath.row];
        AddressModel *addSearch = [[AddressModel alloc] init];
        addSearch.Latitude = item.placemark.coordinate.latitude;
        addSearch.Longitude = item.placemark.coordinate.longitude;
        addSearch.AddressName = item.name;
        addSearch.addressDetailName = item.placemark.addressDictionary[@"FormattedAddressLines"][0];
        [self.delegate didSelectSearchAddress:addSearch];
        [self backup];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
