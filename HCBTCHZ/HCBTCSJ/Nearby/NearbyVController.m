//
//  NearbyVController.m
//  HCBTCHZ
//
//  Created by itte on 16/2/22.
//  Copyright © 2016年 itte. All rights reserved.
//

#import "NearbyVController.h"
#import <MapKit/MapKit.h>
#import "KCAnnotation.h"
#import <CoreLocation/CoreLocation.h>

@interface NearbyVController ()<MKMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;
    MKMapView *_mapView;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (assign, nonatomic) CLLocationCoordinate2D myCoordinate;
@property (copy, nonatomic) NSString *maptitle;
@property (copy, nonatomic) NSString *subMapTitle;
@end

@implementation NearbyVController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self startMap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 添加地图控件
- (void) startMap
{
    CGRect rect = self.view.frame;
    _mapView = [[MKMapView alloc] initWithFrame:rect];
    [self.view addSubview:_mapView];
    _mapView.delegate = self;
    //请求定位服务
    _locationManager=[[CLLocationManager alloc]init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [_locationManager requestWhenInUseAuthorization];
    }
    else if([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        _locationManager.delegate=self;
        //设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance=10.0;//十米定位一次
        _locationManager.distanceFilter=distance;
        //启动跟踪定位
        [_locationManager startUpdatingLocation];
    }
    
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;

    
    //添加大头针
    [self addAnnotation];
        
}

#pragma mark 添加大头针
- (void)addAnnotation
{
    // 显示自己的大头针
    KCAnnotation *annotation1=[[KCAnnotation alloc]init];
    annotation1.title=@"你当前的位置";
    annotation1.subtitle=@"北京广场";
    annotation1.coordinate=self.myCoordinate;
    annotation1.image = [UIImage imageNamed:@"truck.png"];
    [_mapView addAnnotation:annotation1];
}

#pragma mark - 地图代理方法
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[KCAnnotation class]]) {
        return nil;
    }
    static NSString *key = @"keyID";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:key];
    if (!annotation) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:key];
        annotationView.canShowCallout = true;  // 运行交互点击
        annotationView.calloutOffset = CGPointMake(0, 1); //定义详情视图偏移量
        annotationView.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"truck.png"]];
    }
    // 修改大头针视图
    annotationView.annotation = annotation;
    annotationView.image = ((KCAnnotation *) annotation).image;
    return annotationView;
}

#pragma mark - 定位代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    if (locations.count) {
        CLLocation *location = (CLLocation *)[locations lastObject];
        NSLog(@"latitude = %f",location.coordinate.latitude);
        NSLog(@"longitude = %f",location.coordinate.longitude);
        self.myCoordinate = location.coordinate;
        _mapView.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(0.0045f, 0.0045f));
    }
    [_locationManager stopUpdatingLocation];
}
@end
