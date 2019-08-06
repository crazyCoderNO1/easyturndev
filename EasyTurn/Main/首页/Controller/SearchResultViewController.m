//
//  SearchResultViewController.m
//  Fireball
//
//  Created by 任长平 on 2017/12/9.
//  Copyright © 2017年 任长平. All rights reserved.
//

#import "SearchResultViewController.h"
#import "HomeBaseCell.h"
//#import "HomeOneImageCell.h"
//#import "NewsVideoCell.h"
#import "FBRequestSearch.h"
#import "ETEnterpriseServiceTableViewCell1.h"
#import "ETProductModel.h"
@interface SearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)FBRequestSearch *searchModel;
@property(nonatomic, strong)NSMutableArray *aticleArray;
@property(nonatomic, strong)UIView *searchView;
@property (nonatomic, strong) NSMutableArray *products;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchModel.StrKey = self.searchText;
    [self.view addSubview:self.tableView];
    self.aticleArray = [NSMutableArray array];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.searchView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, Screen_Width -20 - 50, 30)];
    self.searchView.backgroundColor = [UIColor xm_colorFromRGB:0xF8F8F8];
    self.searchView.clipsToBounds = YES;
    self.searchView.layer.cornerRadius = 15.0;
    self.navigationItem.titleView = self.searchView;
    WEAKSELF
//    self.tableView.mj_header = [XMRefreshHeader xm_headerWithRefreshingBlock:^{
//        [weakSelf searchAticle];
//    }];
//    [self.tableView.mj_header beginRefreshing];
    [self searchAticle];
}

-(void)searchAticle{
    
//    [FBNetworkTool get:@"articleapi/com.SearchAticle" parameters:self.searchModel.mj_keyValues showHUD:NO responseCache:^(XMHttpResponseModel *responseModel) {
//        NSArray * array = [AticleModel mj_objectArrayWithKeyValuesArray:responseModel.data];
//        [self.aticleArray addObjectsFromArray:array];
//    } success:^(XMHttpResponseModel *responseModel) {
//        [self.tableView.mj_header endRefreshing];
//        if (responseModel.code == 200) {
//            NSArray * array = [AticleModel mj_objectArrayWithKeyValuesArray:responseModel.data];
//            [self.aticleArray addObjectsFromArray:array];
//            [self.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [self.tableView.mj_header endRefreshing];
//    }];
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"page" : @"1",
                             @"pageSize": @"10",
                             @"cityId": @(2),
                             @"keyword" : @"*",
                             @"priceOrder" : @(2)
                             };
    [HttpTool get:[NSString stringWithFormat:@"search/product"] params:params success:^(id responseObj) {
        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"][@"releaseList"];
        for (NSDictionary* prod in responseObj[@"data"][@"releaseList"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
            [_products addObject:p];
        }
        //        NSLog(@"");
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.products.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    AticleModel * model = self.aticleArray[indexPath.row];
//    
//    if (model.ImgUrl.length > 0) {
//        return [HomeOneImageCell heightWithModel:model];
//    }
    return 128;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    HomeBaseCell * cell = [HomeBaseCell cellWithTableView:tableView];
//    cell.model = self.aticleArray[indexPath.row];
    ETEnterpriseServiceTableViewCell1 *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ETProductModel* p=[_products objectAtIndex:indexPath.row];
    cell.giveserviceLab.text=p.title;
    [cell.comImg sd_setImageWithURL:[NSURL URLWithString:p.imageList] placeholderImage:nil];
    cell.moneyLab.text=p.price;
    cell.addressLab.text=p.cityName;
    cell.detailsLab.text=p.detail;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}








-(FBRequestSearch *)searchModel{
    if (!_searchModel) {
        _searchModel = [[FBRequestSearch alloc]init];
    }
    return _searchModel;
}

- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[ETEnterpriseServiceTableViewCell1 class] forCellReuseIdentifier:@"cell"];

        _tableView = tableView;
    }
    return _tableView;
}

@end
