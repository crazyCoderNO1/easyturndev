//
//  ETMineViewController.m
//  EasyTurn
//
//  Created by 程立 on 2019/7/18.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETMineViewController.h"
#import "Masonry.h"
#import "ETMineVIew.h"
#import "ETMETableViewCell.h"
#import "ETVIPViewController.h"
#import "ETAuthenticateViewController.h"
#import "ETPutViewController.h"
#import "ETAccountViewController.h"
#import "UserMegViewController.h"
#import "ETStoreUpViewController.h"
#import "ETProductModel.h"
#import "ETEnterpriseServiceTableViewCell1.h"
#import "ETFrequencyViewController.h"
@interface ETMineViewController ()<UITableViewDataSource,UITableViewDelegate,AccountBindingDelegate>

@property (nonatomic,strong)UITableView        *tableView;
@property (nonatomic,strong)NSMutableArray     *dataSource;
@property (nonatomic, strong) NSMutableArray *products;

@end

static NSString *const cellIdentifier =@"cellIdentifier";
@implementation ETMineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (UITableView *) tableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height-kStatusBarHeight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
//        [_tableView registerClass:[ETMETableViewCell class] forCellReuseIdentifier:cellIdentifier];
        [_tableView registerClass:[ETEnterpriseServiceTableViewCell1 class] forCellReuseIdentifier:@"cell"];

        ETMineVIew *mineview = [[ETMineVIew alloc] init];
        mineview.frame = CGRectMake(0,0,Screen_Width,488);
        mineview.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        mineview.block = ^(NSString * _Nonnull a) {
            [self PostUI:a];
        };
        _tableView.tableHeaderView = mineview;
        _tableView.rowHeight=158;
        mineview.delegate=self;
        
    }
    return _tableView;
}
-(NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource=[NSMutableArray array];
        
    }
    return _dataSource;
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    ETMineVIew*etmine=[[ETMineVIew alloc]init];
    etmine.delegate=self;
    [self PostUI:@"1"];
    [self PostBaiduUI];
}

#pragma mark - 出售全部订单
- (void)PostUI:(NSString*)a {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"pageSize": @"10",
                             @"cityId": @(2),
                             @"releaseTypeId": a
                             };

    [HttpTool get:[NSString stringWithFormat:@"release/orders"] params:params success:^(id responseObj) {
        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"];
        for (NSDictionary* prod in responseObj[@"data"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
            [_products addObject:p];
        }
        //        NSLog(@"");
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}


#pragma mark - 获取百度token
- (void)PostBaiduUI {
    
    NSDictionary *params = @{
                             @"grant_type" : @"client_credentials",
                             @"client_id": @"ECvVABCvGZ6D0huXWzfARIhG",
                             @"client_secret": @"NqPs01HjA2QTotblFGjChovPzKbxcuyv"
                             };
    // 1.获得请求管理者
    //    AFHTTPSessionManager *mgr = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:devHost_Http_App]];
    static AFHTTPSessionManager *mgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mgr = [AFHTTPSessionManager manager];
        
        mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/plain", @"text/javascript", nil];
        mgr.requestSerializer.timeoutInterval = 10;
    });
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    //secret
    NSMutableDictionary *newdic = [NSMutableDictionary dictionaryWithDictionary:params];
//    [newdic setValue:[NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]] forKey:@"timestamp"];
    NSData *jsonData =[NSJSONSerialization dataWithJSONObject:newdic options:NSJSONWritingPrettyPrinted error:nil];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newdic
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    // 2.发送POST请求
    [mgr POST:[NSString stringWithFormat:@"https://aip.baidubce.com/oauth/2.0/token?grant_type=client_credentials&client_id=%@&client_secret=%@&", @"ECvVABCvGZ6D0huXWzfARIhG",@"NqPs01HjA2QTotblFGjChovPzKbxcuyv"] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary* a=responseObject[@"access_token"];
        NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
        [user setObject:responseObject[@"access_token"] forKey:@"access_token"];
        [user synchronize];
        NSLog(@"");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return self.dataSource.count;
    return _products.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ETMETableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    ETEnterpriseServiceTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
     cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ETProductModel* p=[_products objectAtIndex:indexPath.row];
    cell.giveserviceLab.text=p.title;
    [cell.comImg sd_setImageWithURL:[NSURL URLWithString:p.imageList] placeholderImage:nil];
    cell.moneyLab.text=p.price;
    cell.addressLab.text=p.cityName;
    cell.detailsLab.text=p.detail;
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
    return cell;
    
//    ETMETableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell=[[ETMETableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
//    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


- (void)putjumpWeb:(UIButton *)sender {
    ETPutViewController*putVC=[ETPutViewController new];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:putVC animated:YES];
}


-(void)imgjumpWeb:(UIImageView *)sender
{
    UserMegViewController*user=[[UserMegViewController alloc]init];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:user animated:YES];
}

- (void)jumpWebVC:(UIButton*)sender
{
    ETVIPViewController *webVC = [ETVIPViewController new];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)jumpWebVC1:(UIButton*)sender
{
    ETAuthenticateViewController *webVC = [ETAuthenticateViewController new];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)jumpWebVC2:(UIButton*)sender
{
    ETStoreUpViewController *webVC = [ETStoreUpViewController new];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)jumpWebVC3:(UIButton*)sender
{
    ETAccountViewController *webVC = [ETAccountViewController new];
    UIBarButtonItem *backItem = [UIBarButtonItem new];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)jumpWebVC4:(UIButton *)sender {
    ETFrequencyViewController *etfre=[[ETFrequencyViewController alloc]init];
    [self.navigationController pushViewController:etfre animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   ETMETableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 2
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 3点击没有颜色改变
    cell.selected = NO;
}

@end
