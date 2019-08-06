//
//  ETPaymentStagesVC.m
//  EasyTurn
//
//  Created by 刘盖 on 2019/8/5.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETPaymentStagesVC.h"
#import "ETPaymentStatesCell.h"
@interface ETPaymentStagesVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tab;

@property (nonatomic) NSInteger stagesCount;
@end

@implementation ETPaymentStagesVC

+ (instancetype)paymentStagesVC:(NSInteger)stagesCount{
    ETPaymentStagesVC *vc = [[self alloc] init];
    vc.stagesCount = stagesCount;
    return vc;
}

- (UITableView *) tab {
    if (!_tab) {
        _tab=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height) style:UITableViewStylePlain];
        _tab.delegate=self;
        _tab.dataSource=self;
        _tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tab.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        _tab.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0,0,0,0.01)];
        _tab.sectionFooterHeight = 0;
        _tab.sectionHeaderHeight = 10;
        _tab.rowHeight=100;
    }
    return _tab;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"交易详情";
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self.view addSubview:self.tab];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==1) {
        return self.stagesCount+1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1) {
        if (indexPath.row > 0) {
            return [ETPaymentStatesPriceCell cellHeight];
        }
    }
    return [ETPaymentStatesCell cellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *title = @"";
        NSString *subTitle = @"";
        switch (indexPath.section) {
            case 0:
            {
                title = @"最终价格";
                subTitle = self.finalPrice;
            }
                break;
            case 1:
            {
                title = @"支付方式";
                subTitle = @"微信账户";
            }
                break;
            default:
            {
                title = @"确认状态";
                subTitle = @"卖家未确认";
            }
                break;
        }
        return [ETPaymentStatesCell paymentStatesCell:tableView title:title sub:subTitle indexPath:indexPath];
    }
    else{
        return [ETPaymentStatesPriceCell paymentStatesPriceCell:tableView price:[NSString stringWithFormat:@"%ld",[self.finalPrice integerValue]/3] indexPath:indexPath total:self.stagesCount];
    }
}
@end
