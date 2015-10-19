//
//  MapViewController.m
//  51CBY
//
//  Created by SJB on 15/3/17.
//  Copyright (c) 2015年 SJB. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "SJBAnotation.h"


#define IOS8   [[UIDevice currentDevice].systemVersion  doubleValue]>=8.0

#define kWidth  self.view.bounds.size.width
#define kHeight self.view.bounds.size.height

@interface MapViewController ()<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) MKMapView  *mapView;
@property (nonatomic, strong) UIButton *startNav;

@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocationManager *manager;

@property (nonatomic, strong) UISearchBar *searchAddress;

//起点和终点
@property (nonatomic, strong) MKPlacemark *sourceMKPm;
@property (nonatomic, strong) MKPlacemark *destinationMKPm;

//大头针
@property (nonatomic, strong) SJBAnotation *startAnno;
@property (nonatomic, strong) SJBAnotation *endAnno;

@property (nonatomic, strong) NSMutableArray *routeArr;





@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //searchBar
    _searchAddress = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 5, kWidth, 40)] ;
    self.searchAddress.delegate = self;
    self.searchAddress.placeholder = @"重新输入起点";
    [self.view addSubview:self.searchAddress];
    
    //需要iOS8的设置，否则不加载地图
    _manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        
    if (IOS8) {
        
        [self.manager requestWhenInUseAuthorization];
    }
    
    //mapview
    
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 45, kWidth, kHeight-180)];
    self.mapView.delegate = self;
    self.mapView.zoomEnabled = YES;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
   
    [self.view addSubview:self.mapView];
    
    //开始导航按钮
    
    _startNav = [[UIButton alloc] initWithFrame:CGRectMake((kWidth-100)*0.5, CGRectGetMaxY(self.mapView.frame)+20 , 100, 40)];
    [self.startNav setTitle:@"开始导航" forState:UIControlStateNormal];
    [self.startNav setBackgroundColor:[UIColor colorWithRed:64/255.0 green:142/255.0 blue:202/255.0 alpha:1.0]];
    [self.startNav setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startNav addTarget:self action:@selector(startNavigation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startNav];
    
    //大头针 (在外面创建，否则会重复添加)
     _startAnno = [[SJBAnotation alloc] init];
     _endAnno = [[SJBAnotation alloc] init];
    
    _routeArr = [NSMutableArray array];
    
   //解析地名与坐标对应
    _geocoder = [[CLGeocoder alloc] init];
    
}

#pragma mark -- 解析地理位置的方法
//只有地址文字
-(void)geocodeWithSourceName:(NSString *)sourceName toDestinationName:(NSString *)desitinationName
{
        [self.geocoder geocodeAddressString:sourceName completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *startPm = [placemarks firstObject];
        if (startPm == nil) return;
        
        // 添加起点大头针
        
        _startAnno.coordinate = startPm.location.coordinate;
        _startAnno.title = @"当前位置";
        _startAnno.subtitle = sourceName;
        _startAnno.icon = @"mapuser";
        [self.mapView addAnnotation:_startAnno];
        //显示范围
        CLLocationCoordinate2D center = CLLocationCoordinate2DMake(startPm.location.coordinate.latitude, startPm.location.coordinate.longitude);
        MKCoordinateRegion adjustRegion = MKCoordinateRegionMakeWithDistance(center, 1000, 1000);
        [self.mapView setRegion:adjustRegion animated:YES];
        
        [self.geocoder geocodeAddressString:desitinationName completionHandler:^(NSArray *placemarks, NSError *error) {
            CLPlacemark *endPm = [placemarks firstObject];
            if (endPm == nil) return;
            
            // 添加终点大头针
           
            _endAnno.coordinate = endPm.location.coordinate;
            _endAnno.title =  @"加油站";
            _endAnno.subtitle = desitinationName;
            _endAnno.icon = @"mapOil";
            [self.mapView addAnnotation:_endAnno];
            
            [self drawLineWithSourceCLPm:startPm destinationCLPm:endPm];
        }];
    }];
}

#pragma mark --- 画线的方法
//方法1. 有CLPlacemark 画线，适用于全部是文字地址
- (void)drawLineWithSourceCLPm:(CLPlacemark *)sourceCLPm destinationCLPm:(CLPlacemark *)destinationCLPm
{

  
   
    if (sourceCLPm == nil || destinationCLPm == nil) return;
    
    // 1.初始化方向请求
    // 方向请求
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    
    // 设置起点
    MKPlacemark *sourceMKPm = [[MKPlacemark alloc] initWithPlacemark:sourceCLPm];
    request.source = [[MKMapItem alloc] initWithPlacemark:sourceMKPm];
    self.sourceMKPm = sourceMKPm;
    
    // 设置终点
    MKPlacemark *destinationMKPm = [[MKPlacemark alloc] initWithPlacemark:destinationCLPm];
    request.destination = [[MKMapItem alloc] initWithPlacemark:destinationMKPm];
    self.destinationMKPm = destinationMKPm;
    
    // 2.根据请求创建方向
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    
    // 3.执行请求
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (error) return;
        
        [self.routeArr removeAllObjects];
        for (MKRoute *route in response.routes) {
            // 添加路线遮盖（传递路线的遮盖模型数据）
            
            [self.mapView addOverlay:route.polyline];
            [self.routeArr addObject:route];
        }
    }];
    
   
}


#pragma mark - 代理方法,设置画线
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *redender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    redender.lineWidth = 5;
    redender.strokeColor = [UIColor blueColor];
    return redender;
}




//地图定位
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    for (MKRoute *route in self.routeArr) {
        [self.mapView removeOverlay:route.polyline];
    }

    [_geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *placeMark = placemarks[0];
        NSLog(@"placemark:%@",placeMark.name);
        if (self.searchAddress.text.length) {
            [self geocodeWithSourceName: [NSString stringWithFormat:@"上海%@",self.searchAddress.text ] toDestinationName:self.destinationAddress];
        }else{
            
             [self geocodeWithSourceName:placeMark.name toDestinationName:self.destinationAddress];
        }
       
        
    }];
    
    
    
}
//自定义图标

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if (![annotation isKindOfClass:[SJBAnotation class]]) {
        return nil;
    }
    static NSString *annoID = @"annoID";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:annoID];
    if (nil == annoView) {
        annoView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:annoID];
        annoView.canShowCallout = YES;
    }
    [annoView setAnnotation:annotation];
    [annoView setImage:[UIImage imageNamed:((SJBAnotation *)annotation).icon]];
    
    return annoView;
}

#pragma mark -- 调用系统导航
-(void)startNavigation:(UIButton *)sender
{
    if (self.sourceMKPm == nil || self.destinationMKPm == nil) return;
    
    // 起点
    MKMapItem *sourceItem = [[MKMapItem alloc] initWithPlacemark:self.sourceMKPm];
    
    // 终点
    MKMapItem *destinationItem = [[MKMapItem alloc] initWithPlacemark:self.destinationMKPm];
    
    // 存放起点和终点
    NSArray *items = @[sourceItem, destinationItem];
    
    // 参数
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    // 导航模式：驾驶导航
    options[MKLaunchOptionsDirectionsModeKey] = MKLaunchOptionsDirectionsModeDriving;
    // 是否要显示路况
    options[MKLaunchOptionsShowsTrafficKey] = @YES;
    
    // 打开苹果官方的导航应用
    [MKMapItem openMapsWithItems:items launchOptions:options];
}

#pragma mark -- searchBar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    for (MKRoute *route in self.routeArr) {
        [self.mapView removeOverlay:route.polyline];
    }
    
    [searchBar resignFirstResponder];
    [self geocodeWithSourceName:searchBar.text toDestinationName:self.destinationAddress];

    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchAddress resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
