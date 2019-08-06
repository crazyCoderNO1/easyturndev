//
//  ETIssueViewController.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/27.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "ETIssueViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "PopView.h"
#import "PopTableListView.h"
#import "LQCityPicker.h"
#import "LQPickerView.h"
#import "LZCPickerView.h"

@interface ETIssueViewController () <UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PopTableListViewDelegate>

@property (nonatomic,strong)UITableView *tab;
@property (nonatomic,strong)UITextField *titleText;
@property (nonatomic,strong)UITextView *businessText;
@property (nonatomic,strong)UITextField *assetsText;
@property (nonatomic,strong)UITextView *otherText;
@property (nonatomic,strong)UIButton *photoImageView;
@property (nonatomic,strong)UILabel *classificationLabel;
@property (nonatomic,strong)UIButton *classificationBtn;
@property (nonatomic,strong)UILabel *addressLabel;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *taxPaymentLabel;
@property (nonatomic,strong)UIView *effectiveTimeView;
@property (nonatomic,strong)UILabel *effectiveTimeLabel;
@property (nonatomic,strong)UITextField *priceText;
@property (nonatomic,strong)UITextField *priceRangeLeftText;
@property (nonatomic,strong)UITextField *priceRangeRightText;
@property (nonatomic,strong)UITextField *contactText;
@property (nonatomic,strong)UITextField *phoneText;
@property (nonatomic,strong)UIButton *publishBtn;
@property (nonatomic,strong)UIView *priceRangeLeftView;
@property (nonatomic,strong)UIView *priceRangeRightView;
@property (nonatomic,strong)UIViewController * vc;
@property (nonatomic ,strong)PopTableListView *popListView;
@property (nonatomic ,strong)PopTableListView *popEffectiveTimeListView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ETIssueViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _dataSource;
}

-(void)viewWillDisappear:(BOOL)animated {
   [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UITableView *) tab {
    if (!_tab) {
        _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStyleGrouped];
        _tab.delegate=self;
        _tab.dataSource=self;
        _tab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
        _tab.sectionFooterHeight = 0;
        _tab.sectionHeaderHeight = 10;
    }
    return _tab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AipOcrService shardService] authWithAK:@"IuEX5ggSxgyFKLfZCWxtfsmF" andSK:@"PFhnfP7qsMskQpKcZRKwAu8WTY2ivGN3"];
    [self configCallback];
    
    [self loadAddressData];
    
    self.title=@"发布出售";
    self.navigationController.navigationBarHidden=NO;
    [self.view addSubview:self.tab];
    self.tab.contentInsetAdjustmentBehavior = NO;

    
    //添加取消按钮->
    [self addCancelBtn];
}

- (void)loadAddressData{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"Address" ofType:@"plist"];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSArray *provinces = [dic allKeys];
    
    for (NSString *tmp in provinces) {
        
        // 创建第一级数据
        LQPickerItem *item1 = [[LQPickerItem alloc]init];
        item1.name = tmp;
        
        NSArray *arr = [dic objectForKey:tmp];
        NSDictionary *cityDic = [arr firstObject];
        
        NSArray *keys = cityDic.allKeys;
        // 配置第二级数据
        [item1 loadData:keys.count config:^(LQPickerItem *item, NSInteger index) {
            
            item.name = keys[index];
            NSArray *area = [cityDic objectForKey:item.name];
            //            // 配置第三极数据
            //            [item loadData:area.count config:^(LQPickerItem *item, NSInteger index) {
            //                item.name = area[index];
            //            }];
        }];
        
        [self.dataSource addObject:item1];
    }
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *dic = result[@"words_result"][@"经营范围"];
                NSString *words = dic[@"words"];
                [weakSelf.vc dismissViewControllerAnimated:YES completion:^{
                    weakSelf.businessText.text = words;
                }];
//                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
//                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
//                    }else{
//                        [message appendFormat:@"%@: %@\n", key, obj];
//                    }
//
//                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                NSDictionary *dic = result[@"words_result"][1];
                NSString *words = dic[@"words"];
                [weakSelf.vc dismissViewControllerAnimated:YES completion:^{
                    weakSelf.businessText.text = words;
                }];
            }
            
        }else{
            [message appendFormat:@"%@", result];
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }];
        }
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}

//添加取消按钮->
-(void)addCancelBtn{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_leftBack"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 4;
    }else if (section==1) {
        return 1;
    }else if (section==2) {
        return 5;
    }else if (section==3) {
        return 2;
    }else {
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 60;
        }else if (indexPath.row==1) {
            return 110;
        }else if (indexPath.row==2) {
            return 50;
        }else if (indexPath.row==3) {
            return 80;
        }
    }else if (indexPath.section==1) {
        return 100;
    }else if (indexPath.section==2) {
        return 60;
    }else if (indexPath.section==3) {
        if (indexPath.row==0) {
            return 50;
        }else if (indexPath.row==1) {
            return 70;
        }
    }else if (indexPath.section==4) {
        if (indexPath.row==0) {
            return 50;
        }else if (indexPath.row==1) {
            return 50;
        }else if (indexPath.row==2) {
            return 80;
        }
    }
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell* cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"标题："attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            
            [string addAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.000000]} range:NSMakeRange(0, 3)];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(60, 60));
            }];
            
            [cell.contentView addSubview:self.titleText];
            
        }else if (indexPath.row==1) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"经营范围："attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 22));
            }];
            
            [cell.contentView addSubview:self.businessText];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row==2) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"附带资产："attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            
            
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 50));
            }];
            
            [cell.contentView addSubview:self.assetsText];
            
            
        }else if (indexPath.row==3) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"其他信息："attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
            
            
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(20);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 22));
            }];
            
            [cell.contentView addSubview:self.otherText];
        }
    }else if (indexPath.section==1) {
        
        [cell.contentView addSubview:self.photoImageView];
        
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"分类选择"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            
            
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 60));
            }];
            
            [cell.contentView addSubview:self.classificationLabel];
            [cell.contentView addSubview:self.classificationBtn];
            
        }else if (indexPath.row==1) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"注册地址"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 60));
            }];
            
            [cell.contentView addSubview:self.addressLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row==2) {
            
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"注册时间"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 60));
            }];
            
            [cell.contentView addSubview:self.timeLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row==3) {
            
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"纳税类型"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 60));
            }];
            
            [cell.contentView addSubview:self.taxPaymentLabel];
            
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            
        }else if (indexPath.row==4) {
            
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"有效时间"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(76, 60));
            }];
            
            [cell.contentView addSubview:self.effectiveTimeView];
        }
    }else if (indexPath.section==3) {
        if (indexPath.row==0) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"价格"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(30, 50));
            }];
            
            [cell.contentView addSubview:self.priceText];
            
        }else if (indexPath.row==1) {
            
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"价格范围"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(62, 70));
            }];
            
            [cell.contentView addSubview:self.priceRangeLeftView];
            
            UILabel *symbol = [[UILabel alloc]initWithFrame:CGRectMake(90+80, 31, 40, 6)];
            symbol.text = @"~";
            symbol.textColor = RGBACOLOR(180, 180, 180, 1);
            symbol.textAlignment = NSTextAlignmentCenter;
            [cell.contentView addSubview:symbol];
            
            [cell.contentView addSubview:self.priceRangeRightView];
        }
    }else if (indexPath.section==4) {
        if (indexPath.row==0) {
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"联系人"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(46, 50));
            }];
            
            [cell.contentView addSubview:self.contactText];
            
        }else if (indexPath.row==1) {
            
            UILabel *titlelab=[[UILabel alloc]init];
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"联系电话"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
            titlelab.attributedText = string;
            titlelab.textAlignment = NSTextAlignmentLeft;
            titlelab.alpha = 1.0;
            [cell.contentView addSubview:titlelab];
            
            [titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(15);
                make.size.mas_equalTo(CGSizeMake(62, 50));
            }];
            
            [cell.contentView addSubview:self.phoneText];
            
        }else if (indexPath.row==2) {
            
            [cell.contentView addSubview:self.publishBtn];
            
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [_tab deselectRowAtIndexPath:indexPath animated:YES];
    
#pragma mark - 经营范围
    if (indexPath.section == 0 && indexPath.row == 1) {
        self.vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
            
            [[AipOcrService shardService] detectBusinessLicenseFromImage:image
                                                             withOptions:nil
                                                          successHandler:self->_successHandler
                                                             failHandler:self->_failHandler];
            
        }];
        [self presentViewController:self.vc animated:YES completion:nil];
    }
#pragma mark - 注册地址
    if (indexPath.section == 2 && indexPath.row == 1) {
        __weak typeof(self)ws = self;
        [LQCityPicker showInView:self.view datas:self.dataSource didSelectWithBlock:^(NSArray *objs, NSString *dsc) {
            NSLog(@"%@\n%@", objs, dsc);
            ws.addressLabel.text = dsc;
        } cancelBlock:^{
            NSLog(@"cancel");
        }];
    }
    
#pragma mark - 注册时间
    if (indexPath.section == 2 && indexPath.row == 2) {
        __weak typeof(self)ws = self;
        [LZCPickerView showDatePickerWithToolBarText:@"" maxDateStr:[self returnCurrentDay:0] withStyle:[LZCDatePickerStyle new] fromStyle:OtherModulesStyle withCancelHandler:^{
            NSLog(@"quxiaole -----");
            
        } withDoneHandler:^(NSDate *selectedDate) {
            NSLog(@"%@---", selectedDate);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *DateTime = [formatter stringFromDate:selectedDate];
            ws.timeLabel.text = DateTime;
        }];
    }
    
#pragma mark - 纳税类型
    if (indexPath.section == 2 && indexPath.row == 3) {
        [LZCPickerView showSingleColPickerWithToolBarText:@"" withData:@[@"一般纳税人",@"个体工商户",@"法人",@"自然人" ] withDefaultIndex:0 withCancelHandler:^{
            NSLog(@" -----");
            
        } withDoneHandler:^(NSInteger selectedIndex, NSString *selectedValue) {
            NSLog(@"%@---%ld", selectedValue, selectedIndex);
            
            self.taxPaymentLabel.text = selectedValue;

           
        }];
    }
}

- (NSString* )returnCurrentDay:(int)d{
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:d*24*60*60];
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* str = [formatter stringFromDate:date];
    return [NSString stringWithFormat:@"%@-%@-%@",[[str componentsSeparatedByString:@"-"] objectAtIndex:0], [[str componentsSeparatedByString:@"-"] objectAtIndex:1],[[str componentsSeparatedByString:@"-"] objectAtIndex:2]];
}

//取消按钮点击方法
-(void)cancelClick{
    [self finishPublish];
}

#pragma mark - 完成发布
//完成发布
-(void)finishPublish{
    //2.block传值
    if (self.mDismissBlock != nil) {
        self.mDismissBlock();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//block声明方法
-(void)toDissmissSelf:(dismissBlock)block{
    self.mDismissBlock = block;
}

- (UITextField *)titleText{
    if (!_titleText) {
        _titleText = [[UITextField alloc]initWithFrame:CGRectMake(65, 0, Screen_Width-80, 60)];
        _titleText.font = [UIFont systemFontOfSize:15];
        _titleText.placeholder = @"请输入您要发布的标题(公司名称、商品类型)";
    }
    return _titleText;
}

- (UITextView *)businessText{
    if (!_businessText) {
        _businessText = [[UITextView alloc]initWithFrame:CGRectMake(90, 15, Screen_Width-110, 80)];
        _businessText.font = [UIFont systemFontOfSize:15];
        _businessText.textColor = RGBACOLOR(100, 100, 100, 1);
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"(点击右侧按钮可扫描经营范围，扫描后可点击文字修改)";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        [placeHolderLabel sizeToFit];
        [_businessText addSubview:placeHolderLabel];
        
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        [_businessText setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        
    }
    return _businessText;
}

- (UITextField *)assetsText{
    if (!_assetsText) {
        _assetsText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, Screen_Width-100, 50)];
        _assetsText.placeholder = @"请填写附带资产";
        _assetsText.font = [UIFont systemFontOfSize:15];
    }
    return _assetsText;
}

- (UITextView *)otherText{
    if (!_otherText) {
        _otherText = [[UITextView alloc]initWithFrame:CGRectMake(90, 15, Screen_Width-100, 55)];
        _otherText.font = [UIFont systemFontOfSize:15];
        _otherText.textColor = RGBACOLOR(100, 100, 100, 1);
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入公司目前的经营状态、注册地址、到期日等其他详细信息";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = RGBACOLOR(200, 200, 200, 1);
        [placeHolderLabel sizeToFit];
        [_otherText addSubview:placeHolderLabel];
        
        placeHolderLabel.font = [UIFont systemFontOfSize:15];
        [_otherText setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    return _otherText;
}

- (UIButton *)photoImageView{
    if (!_photoImageView) {
        _photoImageView = [[UIButton alloc]initWithFrame:CGRectMake(15, 10, 80, 80)];
        [_photoImageView setBackgroundImage:[UIImage imageNamed:@"出售_分组 2"] forState:UIControlStateNormal];
        [_photoImageView addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoImageView;
}

#pragma mark - 选择图片
- (void)chooseImage{
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册获取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        // 拍照
#pragma mark - 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                                 //                                 [DataMgr shareInstance].presentVC = controller;
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
#pragma mark - 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                                 //                                 [DataMgr shareInstance].presentVC = controller;
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    __weak typeof(self) weakSelf = self;
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        [weakSelf.photoImageView setBackgroundImage:portraitImg forState:UIControlStateNormal];
        
//        HYClipIconViewController *clipVc = [[HYClipIconViewController alloc] initWithImage:portraitImg clipType:HYClipTypeArc];
//        //    clipVc.clipRect = CGRectMake(0, 0, 200, 200);
//        [clipVc didClipImageBlock:^(UIImage *image) {
//            self.iconImageView.image = image;
//
//            NSData *imageData = UIImagePNGRepresentation(image);
//            [SaveToMemory SaveData:imageData ToMemory:[NSString stringWithFormat:@"%@.png",CUR_MemberID]];
//            //图片上传至服务器
//            [self uploadIcon:image];
//        }];
//        [clipVc showClipIconViewController:self];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
        //        [DataMgr shareInstance].presentVC = nil;
    }];
}

#pragma mark image scale utility
#define ORIGINAL_MAX_WIDTH 640.0f
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    //    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    CGSize targetSize = CGSizeMake(150, 150);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
#pragma mark - 修改头像图片尺寸
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark camera utility
- (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL)isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL)doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL)cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

- (UILabel *)classificationLabel{
    if (!_classificationLabel) {
        _classificationLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 40, 60)];
        _classificationLabel.text = @"";
        _classificationLabel.textColor = RGBCOLOR(0.21*255, 0.54*255, 0.97*255);
        _classificationLabel.font = [UIFont systemFontOfSize:15];
        _classificationLabel.textAlignment = NSTextAlignmentRight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(chooseClassify)];
        [_classificationLabel addGestureRecognizer:tap];
        _classificationLabel.userInteractionEnabled = YES;
    }
    return _classificationLabel;
}

- (UIButton *)classificationBtn{
    if (!_classificationBtn) {
        _classificationBtn = [[UIButton alloc]initWithFrame:CGRectMake(90+45, 25, 12, 8)];
        [_classificationBtn setBackgroundImage:[UIImage imageNamed:@"出售_下拉 copy"] forState:UIControlStateNormal];
        [_classificationBtn addTarget:self action:@selector(chooseClassify) forControlEvents:UIControlEventTouchUpInside];
    }
    return _classificationBtn;
}

#pragma mark - 分类选择
- (void)chooseClassify{
    PopView *popView = [PopView popUpContentView:self.popListView direct:PopViewDirection_PopUpBottom onView:self.classificationBtn];
//    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.backgroundColor = [UIColor clearColor];
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, Screen_Width-150, 60)];
        _addressLabel.textColor = RGBACOLOR(100, 100, 100, 1);
        _addressLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addressLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, Screen_Width-150, 60)];
        _timeLabel.textColor = RGBACOLOR(100, 100, 100, 1);
        _timeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeLabel;
}

- (UILabel *)taxPaymentLabel{
    if (!_taxPaymentLabel) {
        _taxPaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, Screen_Width-150, 60)];
        _taxPaymentLabel.textColor = RGBACOLOR(100, 100, 100, 1);
        _taxPaymentLabel.font = [UIFont systemFontOfSize:15];
    }
    return _taxPaymentLabel;
}

- (UIView *)effectiveTimeView{
    if (!_effectiveTimeView) {
        _effectiveTimeView = [[UIView alloc]initWithFrame:CGRectMake(90, 15, 80, 30)];
        _effectiveTimeView.backgroundColor = RGBCOLOR(0.95*255, 0.95*255, 0.95*255);
        _effectiveTimeView.layer.cornerRadius = 2;
        _effectiveTimeView.layer.masksToBounds = YES;
        _effectiveTimeView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(effectiveTime)];
        [_effectiveTimeView addGestureRecognizer:tap];
        
        [_effectiveTimeView addSubview:self.effectiveTimeLabel];
        UIImageView *downImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 10, 12, 8)];
        downImageView.image = [UIImage imageNamed:@"出售_下拉 copy"];
        [_effectiveTimeView addSubview:downImageView];
    }
    return _effectiveTimeView;
}

#pragma mark - 有效时间
- (void)effectiveTime{
    PopView *popView = [PopView popUpContentView:self.popEffectiveTimeListView direct:PopViewDirection_PopUpBottom onView:self.effectiveTimeView];
    //    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.backgroundColor = [UIColor clearColor];
}

- (UILabel *)effectiveTimeLabel{
    if (!_effectiveTimeLabel) {
        _effectiveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        _effectiveTimeLabel.textAlignment = NSTextAlignmentCenter;
        _effectiveTimeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _effectiveTimeLabel;
}

- (UITextField *)priceText{
    if (!_priceText) {
        _priceText = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, 100, 50)];
        _priceText.placeholder = @"¥ 0.00";
        _priceText.font = [UIFont systemFontOfSize:15];
        _priceText.textColor = [UIColor orangeColor];
    }
    return _priceText;
}

- (UIView *)priceRangeLeftView{
    if (!_priceRangeLeftView) {
        _priceRangeLeftView = [[UIView alloc]initWithFrame:CGRectMake(90, 15, 80, 40)];
        _priceRangeLeftView.backgroundColor = RGBCOLOR(0.95*255, 0.95*255, 0.95*255);
        [_priceRangeLeftView addSubview:self.priceRangeLeftText];
    }
    return _priceRangeLeftView;
}

- (UITextField *)priceRangeLeftText{
    if (!_priceRangeLeftText) {

        _priceRangeLeftText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
        _priceRangeLeftText.placeholder = @"¥ 0.00";
        _priceRangeLeftText.font = [UIFont systemFontOfSize:15];
        _priceRangeLeftText.textColor = [UIColor orangeColor];
    }
    return _priceRangeLeftText;
}

- (UIView *)priceRangeRightView{
    if (!_priceRangeRightView) {
        _priceRangeRightView = [[UIView alloc]initWithFrame:CGRectMake(90+80+40, 15, 80, 40)];
        _priceRangeRightView.backgroundColor = RGBCOLOR(0.95*255, 0.95*255, 0.95*255);
        [_priceRangeRightView addSubview:self.priceRangeRightText];
    }
    return _priceRangeRightView;
}

- (UITextField *)priceRangeRightText{
    if (!_priceRangeRightText) {
        _priceRangeRightText = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, 70, 40)];
        _priceRangeRightText.placeholder = @"¥ 0.00";
        _priceRangeRightText.font = [UIFont systemFontOfSize:15];
        _priceRangeRightText.textColor = [UIColor orangeColor];
    }
    return _priceRangeRightText;
}

- (UITextField *)contactText{
    if (!_contactText) {
        _contactText = [[UITextField alloc]initWithFrame:CGRectMake(Screen_Width-20-100, 0, 100, 50)];
        _contactText.placeholder = @"点击输入姓名";
        _contactText.textAlignment = NSTextAlignmentRight;
        _contactText.font = [UIFont systemFontOfSize:15];
    }
    return _contactText;
}

- (UITextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc]initWithFrame:CGRectMake(Screen_Width-20-120, 0, 120, 50)];
        _phoneText.placeholder = @"点击输入手机号";
        _phoneText.font = [UIFont systemFontOfSize:15];
        _phoneText.textAlignment = NSTextAlignmentRight;
        _phoneText.textColor = [UIColor orangeColor];
    }
    return _phoneText;
}

- (UIButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 20, Screen_Width-120, 40)];
        _publishBtn.layer.cornerRadius = 6;
        _publishBtn.backgroundColor=[UIColor colorWithRed:20/255.0 green:138/255.0 blue:236/255.0 alpha:1.0];
        [_publishBtn setTitle:@"确认发布" forState:UIControlStateNormal];
        [_publishBtn addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchUpInside];
    }
    return _publishBtn;
}

- (PopTableListView *)popListView{
    if (_popListView == nil) {
        _popListView = [[PopTableListView alloc] initWithTitles:@[@"综合",@"金融",@"贸易",@"投资",@"工程",@"科技",@"其他"] imgNames:nil type:@"1"];
        _popListView.backgroundColor = [UIColor whiteColor];
        _popListView.layer.cornerRadius = 5;
        _popListView.delegate = self;
    }
    return _popListView;
}

- (PopTableListView *)popEffectiveTimeListView{
    if (_popEffectiveTimeListView == nil) {
        _popEffectiveTimeListView = [[PopTableListView alloc] initWithTitles:@[@"30天",@"60天",@"120天",@"360天"] imgNames:nil type:@"2"];
        _popEffectiveTimeListView.backgroundColor = [UIColor whiteColor];
        _popEffectiveTimeListView.layer.cornerRadius = 5;
        _popEffectiveTimeListView.delegate = self;
    }
    return _popEffectiveTimeListView;
}

- (void)selectType:(NSString *)name type:(NSString *)type{
    
    [PopView hidenPopView];
    
    if ([type isEqualToString:@"1"]) {
        self.classificationLabel.text = name;
    }else{
        self.effectiveTimeLabel.text = name;
    }
    
}
-(void)publish
{
    [self PostUI];
}
#pragma mark - 发布
- (void)PostUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"accuratePush" : @"1",
                             @"asset": @"10",
                             @"browse" : @(0),
                             @"business" : @"1",
                             @"buyUserId" : @(0),
                             @"cityId" : @(0),
                             @"cityName" : @"1",
                             @"detail" : @"1",
                             @"freePush" : @(0),
                             @"higherPrice" : @(0),
                             @"imageList" : @"1",
                             @"information" : @"1",
                             @"isDel" : @(0),
                             @"linkmanId" : @(0),
                             @"linkmanMobil" : @"1",
                             @"linkmanName" : @"1",
                             @"lowerPrice" : @(0),
                             @"price" : @(0),
                             @"releaseId" : @(0),
                             @"releaseTime" : @"2019-08-05T07:47:43.640Z",
                             @"releaseTypeId" : @(0),
                             @"selectId" : @(0),
                             @"serviceId" : @(0),
                             @"taxId" : @(0),
                             @"title" : @"出售丰台公司",
                             @"tradStatus" : @(0),
                             @"userId" : @(0),
                             @"validId" : @(0)
                             };
    
    [HttpTool post:[NSString stringWithFormat:@"release/releaseService"] params:params success:^(id responseObj) {
        NSDictionary* a=responseObj[@"data"];
                NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

@end
