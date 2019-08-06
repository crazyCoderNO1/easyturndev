//
//  ETPaymentStatesCell.m
//  EasyTurn
//
//  Created by 刘盖 on 2019/8/5.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETPaymentStatesCell.h"

@interface ETPaymentStatesCell()

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UILabel *labelSubTitle;
@property (nonatomic,strong) UIImageView *imvLine;
@end

@implementation ETPaymentStatesCell

+ (CGFloat)cellHeight{
    return 50;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat cellH = [ETPaymentStatesCell cellHeight];
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        self.labelTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:self.labelTitle];
        self.labelTitle.frame = CGRectMake(15, 0, (Screen_Width-15*2-20)/2, cellH);
        
        self.labelSubTitle = [[UILabel alloc] init];
        self.labelSubTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        self.labelSubTitle.textAlignment = NSTextAlignmentRight;
        self.labelSubTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:self.labelSubTitle];
        self.labelSubTitle.frame = CGRectMake(CGRectGetMaxX(self.labelTitle.frame)+20, 0, (Screen_Width-15*2-20)/2, cellH);
        
        self.imvLine = [[UIImageView alloc] init];
        self.imvLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:self.imvLine];
    }
    return self;
}

- (void)resetWithTitle:(NSString *)title sub:(NSString *)sub indexPath:(NSIndexPath *)indexPath{
    self.labelTitle.text = title;
    if (indexPath.section == 0) {
        self.labelSubTitle.text = [NSString stringWithFormat:@"￥%@元",sub];
    }
    else{
        self.labelSubTitle.text = sub;
    }
    if (indexPath.section == 0) {
        self.labelSubTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        self.labelSubTitle.textColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:43/255.0 alpha:1.0];
    }
    else{
        self.labelSubTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        self.labelSubTitle.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    }
    
    self.imvLine.hidden = NO;
    if (indexPath.section <= 1) {
        self.imvLine.frame = CGRectMake(15, CGRectGetMaxY(self.labelTitle.frame)-1, Screen_Width-15*2, 1);
    }
    else{
        self.imvLine.hidden = YES;
    }
}

+ (instancetype)paymentStatesCell:(UITableView *)tableView title:(NSString *)title sub:(NSString *)sub indexPath:(NSIndexPath *)indexPath{
    ETPaymentStatesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ETPaymentStatesCell"];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ETPaymentStatesCell"];
    }
    [cell resetWithTitle:title sub:sub indexPath:indexPath];
    return cell;
}
@end


@interface ETPaymentStatesPriceCell()

@property (nonatomic,strong) UILabel *labelTitle;
@property (nonatomic,strong) UILabel *labelSubTitle;
@property (nonatomic,strong) UIButton *btnPay;
@property (nonatomic,strong) UIImageView *imvLine;
@end

@implementation ETPaymentStatesPriceCell

+ (CGFloat)cellHeight{
    return 90;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat cellH = [ETPaymentStatesPriceCell cellHeight];
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 15];
        self.labelTitle.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        [self.contentView addSubview:self.labelTitle];
        self.labelSubTitle.frame = CGRectMake(45, 0, (Screen_Width-15*2-20)/2, cellH);
        
        self.labelSubTitle = [[UILabel alloc] init];
        self.labelSubTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 12];
        self.labelSubTitle.text = @"未支付";
        self.labelSubTitle.textAlignment = NSTextAlignmentRight;
        self.labelSubTitle.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        [self.contentView addSubview:self.labelSubTitle];
        self.labelSubTitle.frame = CGRectMake(CGRectGetMaxX(self.labelTitle.frame)+20, 0, (Screen_Width-15*2-20)/2, cellH);
        
        self.btnPay = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnPay.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size: 13];
        self.btnPay.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        self.btnPay.clipsToBounds = YES;
        [self.btnPay setTitle:@"去支付" forState:UIControlStateNormal];
        [self.btnPay setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.contentView addSubview:self.btnPay];
        
        self.imvLine = [[UIImageView alloc] init];
        self.imvLine.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
        [self.contentView addSubview:self.imvLine];
        
        self.labelSubTitle.frame = CGRectMake(Screen_Width-15-50, 15, 50, self.labelTitle.font.lineHeight);
        self.labelTitle.frame = CGRectMake(45, 15, CGRectGetMinX(self.labelSubTitle.frame)-45, self.labelTitle.font.lineHeight);
        self.btnPay.frame = CGRectMake(CGRectGetMinX(self.labelTitle.frame), CGRectGetMaxY(self.labelTitle.frame)+10, 60, 30);
        self.btnPay.layer.cornerRadius = 2.5;
        
        self.imvLine.frame = CGRectMake(15, cellH-1, Screen_Width-15*2, 1);
        
    }
    return self;
}

- (void)resetWithPrice:(NSString *)price indexPath:(NSIndexPath *)indexPath total:(NSInteger)total{
    NSString *temp = @"";
    if (indexPath.row == 1) {
        temp = @"第一期，买家付金额";
    }
    else if (indexPath.row == 2){
        temp = @"第二期，买家付金额";
    }
    else{
        temp = @"第三期，买家付金额";
    }
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:temp attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    [title appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@元",price] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:248/255.0 green:124/255.0 blue:43/255.0 alpha:1.0]}]];
    self.labelTitle.attributedText = title;
    self.imvLine.hidden = YES;
    if (indexPath.row<total) {
        self.imvLine.hidden = NO;
    }
}

+ (instancetype)paymentStatesPriceCell:(UITableView *)tableView price:(NSString *)price indexPath:(NSIndexPath *)indexPath total:(NSInteger)total{
    ETPaymentStatesPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ETPaymentStatesPriceCell"];
    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ETPaymentStatesPriceCell"];
    }
    [cell resetWithPrice:price indexPath:indexPath total:total];
    return cell;
}
@end
