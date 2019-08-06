//
//  ETStoreUpViewController.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/23.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "ETStoreUpViewController.h"
#import "ETEnterpriseServiceTableViewCell1.h"
#import "ETProductModel.h"
@interface ETStoreUpViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tab;
@property(nonatomic,strong)UIButton *loadingBtn;
@property(nonatomic,strong)NSMutableArray*products;
@end

@implementation ETStoreUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title=@"我的收藏";
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:self.tab];
    [self.view addSubview:self.loadingBtn];
    [self.tab registerClass:[ETEnterpriseServiceTableViewCell1 class] forCellReuseIdentifier:@"cell"];
     [self PostUI:@"1"];
}


- (UITableView *)tab
{
    if (!_tab) {
        _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width) style:UITableViewStylePlain];
        _tab.delegate=self;
        _tab.dataSource=self;
        _tab.rowHeight=158;
    }
    return _tab;
}

- (UIButton *)loadingBtn {
    if (!_loadingBtn) {
        _loadingBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 400, self.view.frame.size.width, 50)];
        [_loadingBtn setTitle:@"点击加载更多" forState:UIControlStateNormal];
        [_loadingBtn setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }
    return _loadingBtn;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _products.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ETEnterpriseServiceTableViewCell1*cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tab deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    // 2
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    // 3点击没有颜色改变
    cell.selected = NO;
}

- (void)PostUI:(NSString*)head {
    NSDictionary *params = @{
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    
    [HttpTool get:[NSString stringWithFormat:@"collect/my"] params:params success:^(NSDictionary *response) {
        //        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        //        NSLog(@"%@",jsonDict);
        _products=[NSMutableArray new];
        NSDictionary* a=response[@"data"];
        for (NSDictionary* prod in response[@"data"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
            if (p) {
                [_products addObject:p];
            }
        }
        [_tab reloadData];
    } failure:^(NSError *error) {
        
    }];
}
@end
