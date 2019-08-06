//
//  ETVIPViewController.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/20.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "ETVIPViewController.h"
#import "MEVIPTableViewCell.h"
#import "ETProductModel.h"
#import "ETMineModel.h"
@interface ETVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tab;
@property(nonatomic,strong)NSMutableArray*products;
@end

@implementation ETVIPViewController

-(UITableView *)tab {
    if (!_tab) {
        _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
        _tab.delegate=self;
        _tab.dataSource=self;
        _tab.rowHeight=60;
        [_tab registerClass:[MEVIPTableViewCell class] forCellReuseIdentifier:@"cell"];
         _tab.tableFooterView = [[UIView alloc]init];
    }
    return _tab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden=NO;
    self.title=@"VIP会员";
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:47/255.0 green:134/255.0 blue:251/255.0 alpha:1.0];
    [self PostUI];
    [self PostUI:@"1"];
     [self.view addSubview:self.tab];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MEVIPTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    ETMineModel *m=[_products objectAtIndex:indexPath.row];
    cell.titleLab.text=m.title;
    cell.subTitleLab.text=m.money;
    [cell.subBtn setTitle:@"购买" forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tab deselectRowAtIndexPath:indexPath animated:YES];
    
    MEVIPTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 2
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 3点击没有颜色改变
    
    cell.selected = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - 用户信息
- (void)PostUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSUserDefaults* user=[NSUserDefaults standardUserDefaults];
    if (![user objectForKey:@"uid"]) {
        return;
    }
    NSDictionary *params = @{
                             @"uid" : [user objectForKey:@"uid"]
                             };
    
    [HttpTool get:[NSString stringWithFormat:@"user/info"] params:params success:^(id responseObj) {
        //        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"];
        UserInfoModel* info=[UserInfoModel mj_objectWithKeyValues:responseObj[@"data"][@"userInfo"]];
        //        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: "attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0]}];
        //        _companyLab.attributedText = string;
        //            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
        //            [_products addObject:p];
        //        _nameStr=info.name;
        NSLog(@"");
        [_tab reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)PostUI:(NSString*)head {
//    NSData *data =    [NSJSONSerialization dataWithJSONObject:nil options:NSUTF8StringEncoding error:nil];
    
    [HttpTool get:[NSString stringWithFormat:@"buy/getVipList"] params:nil success:^(NSDictionary *response) {
        _products=[NSMutableArray new];
        NSDictionary* a=response[@"data"];
        for (NSDictionary* prod in response[@"data"][@"list"]) {
            ETMineModel *m=[ETMineModel mj_objectWithKeyValues:prod];
//            if (m) {
                 [_products addObject:m];
//            }
        }
        [_tab reloadData];

    } failure:^(NSError *error) {
        
    }];
}
@end
