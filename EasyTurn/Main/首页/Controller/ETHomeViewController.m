//
//  ETHomeViewController.m
//  EasyTurn
//
//  Created by 程立 on 2019/7/19.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETHomeViewController.h"
#import "ETHomeTopView.h"
#import "ETHomeHeaderView.h"
#import "ETHomeModel.h"
#import "MarqueeView.h"
#import "ETHomeLocationController.h"
#import "JMColumnMenu.h"
#import "AticleMenu.h"
#import "ETEnterpriseServiceTableViewCell1.h"
#import "ETProductModel.h"
#import "FBSearchViewController.h"
#import "ETProductDetailController.h"
#import <CoreLocation/CoreLocation.h>
#import "CityListViewController.h"
#import "ETRealtimePurchaseViewController.h"
#import "IANshowLoading.h"
@interface ETHomeViewController ()<UITableViewDelegate, UITableViewDataSource, ETHomeHeaderViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager* manager;
}
@property (nonatomic, strong) ETHomeTopView *vHomeTop;
@property (nonatomic, strong) ETHomeHeaderView *vHomeHeader;
@property (nonatomic, strong) UITableView *tbHome;
@property (nonatomic, strong) MarqueeView *marqueeView;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableArray *serviceIdarr;
@end

@implementation ETHomeViewController

- (MarqueeView *)marqueeView{
    
    if (!_marqueeView) {
        NSMutableArray *arr1=[NSMutableArray array];
        for (ETProductModel*p in _serviceIdarr) {
            [arr1 addObject:p.title];
        }
        MarqueeView *marqueeView =[[MarqueeView alloc]initWithFrame:CGRectMake(0, 290, 300, 30) withTitle:@[@"1",@"2",@"3"]];
        marqueeView.titleColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        marqueeView.titleFont = [UIFont systemFontOfSize:12];
        __weak MarqueeView *marquee = marqueeView;
        
        marqueeView.handlerTitleClickCallBack = ^(NSInteger index){
//            ETProductModel *p=self->_serviceIdarr[index];
            NSLog(@"%@----%zd",marquee.titleArr[index-1],index);
            ETRealtimePurchaseViewController *etrealTime=[[ETRealtimePurchaseViewController alloc]init];
            [self.navigationController pushViewController:etrealTime animated:YES];
            
        };
        _marqueeView = marqueeView;
    }
    return _marqueeView;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (UITableView *)tbHome {
    if (!_tbHome) {
        _tbHome = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusBarHeight + 65, Screen_Width, Screen_Height - kStatusBarHeight - 65) style:UITableViewStylePlain];
        _tbHome.showsVerticalScrollIndicator = NO;
        _tbHome.backgroundColor = kACColorWhite;
        _tbHome.delegate = self;
        _tbHome.dataSource = self;
        _vHomeHeader = [[ETHomeHeaderView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 327)];
        _vHomeHeader.delegate = self;
        _tbHome.tableHeaderView = _vHomeHeader;
        _tbHome.tableFooterView = [[UIView alloc]init];
    }
    return _tbHome;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.serviceIdarr=[NSMutableArray array];
    [self createSubViewsAndConstraints];
    [self requestDate];
    [self.vHomeHeader addSubview:self.marqueeView];
    [self PostUI];
    [self location];
}

#pragma mark - 动态列表
- (void)PostUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"pageSize": @"10",
                             @"cityId": @(2)
                             };
    [HttpTool get:[NSString stringWithFormat:@"release/dynamic"] params:params success:^(id responseObj) {
        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"];
        for (NSDictionary* prod in responseObj[@"data"][@"rows"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
            [_products addObject:p];
            if ([p.serviceId isEqualToString:@"2"]) {
                [_serviceIdarr addObject:p];
            }
        }
//        NSLog(@"");
        [_tbHome reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - 产品搜索
- (void)PostSearchUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"pageSize": @"10",
                             @"cityId": @(2),
                             @"keyword" : @"营业",
                             @"priceOrder" : @(2)
                             };
    [HttpTool get:[NSString stringWithFormat:@"search/product"] params:params success:^(id responseObj) {
        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"][@"productList"];
        for (NSDictionary* prod in responseObj[@"data"][@"productList"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
            [_products addObject:p];
        }
        //        NSLog(@"");
        [_tbHome reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)location
{
    manager = [[CLLocationManager alloc]init];//初始化一个定位管理对象
    [manager requestAlwaysAuthorization];//申请定位服务权限
    //    [manager requestWhenInUseAuthorization];
    manager.delegate=self;//设置代理
    [manager startUpdatingLocation];//开启定位服务
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@",locations);
    //位置坐标
    CLLocation *location=[locations firstObject];
    
    
    _coordinate=location.coordinate;
    
    NSLog(@"您的当前位置:经度：%f,纬度：%f,海拔：%f,航向：%f,速度：%f",_coordinate.longitude,_coordinate.latitude,location.altitude,location.course,location.speed);
    [self PostCityUI];
    [manager stopUpdatingLocation];
}

#pragma mark -  获取cityID
- (void)PostCityUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"lat" : [NSString stringWithFormat:@"%f", _coordinate.latitude ],
                             @"lng": [NSString stringWithFormat:@"%f", _coordinate.longitude ]
                             };
    [HttpTool get:[NSString stringWithFormat:@"city/getCityByLocation"] params:params success:^(id responseObj) {

        [_vHomeTop.btnLocationDown setTitle:responseObj[@"data"][@"name"] forState:UIControlStateNormal];
        //cityId
        NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
        [user setObject:responseObj[@"data"][@"id"] forKey:@"cityid"];
        [user setObject:responseObj[@"data"][@"name"] forKey:@"cityname"];
        [user synchronize];
        //        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark - createSubViewsAndConstraints
- (void)createSubViewsAndConstraints {
    
    _vHomeTop = [[ETHomeTopView alloc]init];
    [self.view addSubview:_vHomeTop];
    _vHomeTop.block = ^{
//        ETHomeLocationController* loc=[ETHomeLocationController new];
//        
//        AticleMenu* memu=[AticleMenu new];
//        memu.Text=@"交易";
//        NSMutableArray *arr1 = [NSMutableArray new];
//        NSMutableArray *arr2 = [NSMutableArray new];
//        [arr1 addObject:memu];
//        [arr2 addObject:memu];
//        JMColumnMenu *menuVC = [JMColumnMenu columnMenuWithTagsArrM:arr1 OtherArrM:arr2 Type:JMColumnMenuTypeTouTiao Delegate:self];
//        [self presentViewController:menuVC animated:YES completion:nil];
//        [loc.view addSubview:menuVC.view];
        
        CityListViewController* loc=[CityListViewController new];
        loc.delegate = self;
        //热门城市列表
        loc.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州",@"北京",@"天津",@"厦门",@"重庆",@"福州",@"泉州",@"济南",@"深圳",@"长沙",@"无锡", nil];
        //历史选择城市列表
        loc.arrayHistoricalCity = [NSMutableArray arrayWithObjects:@"福州",@"厦门",@"泉州", nil];
        //定位城市列表
        NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
        loc.arrayLocatingCity   = [NSMutableArray arrayWithObjects:[user objectForKey:@"cityname"], nil];
        [self.navigationController pushViewController:loc animated:YES];
        

    };
    [_vHomeTop mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kStatusBarHeight + 75);
    }];
    
    [self.view addSubview:self.tbHome];
 
}
- (void)didClickedWithCityName:(NSString*)cityName
{
    NSLog(@"%@",cityName);
    [_vHomeTop.btnLocationDown setTitle:cityName forState:UIControlStateNormal];

}
#pragma mark - 请求网络
- (void)requestDate {
    WEAKSELF
    //    [[ACToastView toastView]showLoadingCircleViewWithStatus:@"正在加载中"];
    [IANshowLoading showLoadingForView:self.view];
    [ETHomeModel requestGetIndexBannerSuccess:^(id request, STResponseModel *response, id resultObject) {
        if (response.code == 0) {
    //            [[ACToastView toastView]hide];
            [IANshowLoading hideLoadingForView:self.view];
            ETHomeModel *model = response.data;
            NSMutableArray *imageGroupArray = [NSMutableArray array];
            [model.adList enumerateObjectsUsingBlock:^(AdListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [imageGroupArray addObject:obj.image];
            }];
            weakSelf.vHomeHeader.imageGroupArray = imageGroupArray;
            [weakSelf.tbHome reloadData];
        }
    } failure:^(id request, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _products.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ETEnterpriseServiceTableViewCell1* cell = [[ETEnterpriseServiceTableViewCell1 alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_products.count>0) {
        ETProductModel* p=[_products objectAtIndex:indexPath.row];
                           cell.serviceLab.text=p.desc;
        cell.giveserviceLab.text=p.title;
        if ([p.releaseId isEqualToString:@"1001"]) {
            cell.serviceLab.text=@"出售";
        }else if ([p.releaseId isEqualToString:@"1002"]) {
            cell.serviceLab.text=@"求购";
        }else if ([p.releaseId isEqualToString:@"1003"]) {
            cell.serviceLab.text=@"服务";
        }
        cell.moneyLab.text=[NSString stringWithFormat:@"¥%@",p.price];
    
        cell.addressLab.text=p.cityName;
        cell.detailsLab.text=p.business;
                           [cell.comImg sd_setImageWithURL:[NSURL URLWithString:p.imageList]];
        if ([p.releaseTypeId isEqualToString:@"1"]) {
            UIImageView* jiao=[UIImageView new];
            [jiao setImage:[UIImage imageNamed:@"首页_出售"]];
            [cell.comImg addSubview:jiao];
            [jiao mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(35);
            }];
        }
        if ([p.releaseTypeId isEqualToString:@"3"]) {
            UIImageView* jiao=[UIImageView new];
            [jiao setImage:[UIImage imageNamed:@"首页_企服者"]];
            [cell.comImg addSubview:jiao];
            [jiao mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(35);
            }];
        }
        if ([p.releaseTypeId isEqualToString:@"2"]) {
            UIImageView* jiao=[UIImageView new];
            [jiao setImage:[UIImage imageNamed:@"首页_求购"]];
            [cell.comImg addSubview:jiao];
            [jiao mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(35);
            }];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 128;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ETProductDetailController* detail=[ETProductDetailController new];
    ETProductModel* p =[_products objectAtIndex:indexPath.row];
    detail.releaseId=p.releaseId;
    detail.product=p;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -ETHomeHeaderViewDelegate
- (void)homeHeaderViewPushSearch {
    AMLog(@"11");
    FBSearchViewController* search = [FBSearchViewController new];
    [self.navigationController pushViewController:search animated:YES];
    
}

- (void)slideshowHeadViewDidSelectItemAtIndex:(NSInteger)index {
    
}

@end
