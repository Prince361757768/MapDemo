//
//  ViewController.m
//  MapDemo
//
//  Created by Y杨定甲 on 16/2/29.
//  Copyright © 2016年 damai. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapSearchKit/AMapCommonObj.h>
@interface ViewController ()<MAMapViewDelegate,AMapSearchDelegate>
{
    MAMapView *_mapView;
    MAPointAnnotation *pointAnnotation;
    AMapSearchAPI *_search;
    NSString *locationText;
    CLLocationCoordinate2D locationCoordinate;
}
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    //配置用户Key
    [MAMapServices sharedServices].apiKey = @"d8b0c5c5a92678c1171dd2994aea1c56";
    pointAnnotation = [[MAPointAnnotation alloc]init];
    
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = @"d8b0c5c5a92678c1171dd2994aea1c56";
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.delegate = self;
    _mapView.showsScale= NO;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    [self setAnnotation];
}
//这是一个假的定位，Demo
- (void)setAnnotation{
    /*
     在地图上添加一个标注的步骤如下：
     
     1） 定义一个 MAPointAnnotation 对象，添加数据；
     
     2） 使用 MAMapView 的 addAnnotation: 方法添加到地图；
     
     3） 实现 mapView:viewForAnnotation: 代理方法；
     
     4） 在代理内定义 MAPinAnnotationView 对象。
     */
    MAPointAnnotation *point = [[MAPointAnnotation alloc]init];
    point.coordinate = CLLocationCoordinate2DMake(39.936227, 116.337364);
    point.title = @"动物园";
    point.subtitle = @"这是一条假数据";
    [_mapView addAnnotation:point];
    
}

- (void)setAnnotationWithUserLocation:(CLLocationCoordinate2D)locationCoordinate2D{
    
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(locationCoordinate2D.latitude, locationCoordinate2D.longitude);
    pointAnnotation.title = locationText;
    [_mapView addAnnotation:pointAnnotation];
}

#pragma mark - mapView:viewForAnnotation:回调函数，自定义标注样式。
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop = YES; //设置标注动画显示，默认为NO 与image冲突
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        annotationView.image = [UIImage imageNamed:@"buyerLocation"];
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        annotationView.centerOffset = CGPointMake(0, -18);
        
        return annotationView;
    }
    return nil;
}
#pragma mark - 位置更新回调函数
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        
        [self getLocation:userLocation.coordinate];
        locationCoordinate = userLocation.coordinate;
    }
}
#pragma mark -- 逆地理编码
- (void)getLocation:(CLLocationCoordinate2D)userLocationCoordinate;
{
    //构造AMapReGeocodeSearchRequest对象，location为必选项，radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
//    regeoRequest.searchType = AMapSearchType_ReGeocode;
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:userLocationCoordinate.latitude  longitude:userLocationCoordinate.longitude];
    //    regeoRequest.location = [AMapGeoPoint locationWithLatitude:23.11  longitude:113.27];
    regeoRequest.radius = 10000;
    regeoRequest.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeoRequest];
    
}
#pragma mark - 逆地理编码回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
//        NSString *result = [NSString stringWithFormat:@"ReGeocode: %@", response.regeocode];
        
        locationText = response.regeocode.formattedAddress;
        [self setAnnotationWithUserLocation:locationCoordinate];
    }
    //stop以后可以关掉蓝点
//    [self stopLocation];
}

#pragma 关闭定位服务

/**
 *  关闭定位服务
 */
-(void)stopLocation
{
    _mapView.showsUserLocation = NO;
    _mapView.delegate = nil;
    _search.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
