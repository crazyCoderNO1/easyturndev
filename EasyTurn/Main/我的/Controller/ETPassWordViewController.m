//
//  ETPassWordViewController.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/23.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "ETPassWordViewController.h"
@interface ETPassWordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tab;
@property(nonatomic,strong)NSMutableArray *products;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)UILabel *numberlab;
@property(nonatomic,strong)UITextField*numberText;
@property(nonatomic,strong)UILabel *newnumberlab;
@property(nonatomic,strong)UITextField*newnumberText;
@property(nonatomic,strong)UILabel *queneLab;
@property(nonatomic,strong)UITextField*queneText;
@end

@implementation ETPassWordViewController

-(UITableView *)tab {
    if (!_tab) {
        _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
        _tab.delegate=self;
        _tab.dataSource=self;
        _tab.tableFooterView = [[UIView alloc]init];
        _tab.rowHeight=55.5;
    }
    return _tab;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(baocun)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem.tintColor=[UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"设置密码";
    self.navigationController.navigationBar.titleTextAttributes=
    @{NSForegroundColorAttributeName:[UIColor whiteColor],
      NSFontAttributeName:[UIFont systemFontOfSize:18]};
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:47/255.0 green:134/255.0 blue:251/255.0 alpha:1.0];
    [self.view addSubview:self.tab];
    [self PostUI];
   
}
- (void)baocun {
    [self PostUI:_newnumberText.text];
}
#pragma mark - 设置密码
//- (void)PostUI {
//    _password=@"123455";
//    NSDictionary *params = @{
//                             @"password":_password
//                             };
//    [HttpTool get:[NSString stringWithFormat:@"user/setPassword"] params:params success:^(id responseObj) {
//          _products=[NSMutableArray new];
//          NSDictionary* a=responseObj[@"data"];
//        for (NSDictionary* prod in responseObj[@"data"]) {
//            [_newnumberlab addSubview:_password];            
//        }
////        //        NSLog(@"");
////        ETProductModel* p=[ETProductModel mj_objectWithKeyValues:a];
//        NSLog(@"");
////        [_products addObject:p];
//        [_tab reloadData];
//    } failure:^(NSError *error) {
//        NSLog(@"%@",error);
//    }];
//}


//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 2;
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0) {
        _numberlab=[[UILabel alloc]init];
        [cell addSubview:_numberlab];
        _numberlab.text=@"请输入原密码";
        _numberlab.font=[UIFont systemFontOfSize:12];
        _numberlab.textColor=[UIColor blackColor];
        [_numberlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(95, 21));
        }];
        
        _numberText=[[UITextField alloc]init];
//        text1.placeholder=@"输入密码";
        [cell addSubview:_numberText];
        
        [_numberText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
             make.left.mas_equalTo(109);
             make.size.mas_equalTo(CGSizeMake(100, 32));
            
        }];
        
    }else if (indexPath.row==1) {
        _newnumberlab=[[UILabel alloc]init];
        [cell addSubview:_newnumberlab];
        _newnumberlab.text=@"请输入密码";
//         [self PostUI];
        _newnumberlab.font=[UIFont systemFontOfSize:12];
        _newnumberlab.textColor=[UIColor blackColor];
        [_newnumberlab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(95, 21));
        }];
        
        _newnumberText=[[UITextField alloc]init];
        //        text1.placeholder=@"输入密码";
        [cell addSubview:_newnumberText];
        
        [_newnumberText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(109);
            make.size.mas_equalTo(CGSizeMake(100, 32));
            
        }];
    }else if (indexPath.row==2){
        _queneLab=[[UILabel alloc]init];
        [cell addSubview:_queneLab];
        _queneLab.text=@"确认密码";
        _queneLab.font=[UIFont systemFontOfSize:12];
        _queneLab.textColor=[UIColor blackColor];
        [_queneLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(17);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(95, 21));
        }];
        
        _queneText=[[UITextField alloc]init];
        //        text1.placeholder=@"输入密码";
        [cell addSubview:_queneText];
        
        [_queneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(109);
            make.size.mas_equalTo(CGSizeMake(100, 32));
            
        }];
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
        
        NSLog(@"");
        [_tab reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

- (void)PostUI:(NSString*)head {
    NSDictionary *params = @{
                             @"NewPassword" :_newnumberText.text,
                             @"OldPassword" :_numberText.text
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];

    [HttpTool put:[NSString stringWithFormat:@"user/updatePassword"] params:params success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"%@",jsonDict);
    } failure:^(NSError *error) {

    }];
}
@end
