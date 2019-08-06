//
//  MEVIPTableViewCell.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/22.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "MEVIPTableViewCell.h"

@implementation MEVIPTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        [self addSubview:self.titleLab];
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.left.mas_equalTo(15);
            make.size.mas_equalTo(CGSizeMake(57, 22));
        }];
        
        [self addSubview:self.subTitleLab];
        [self.subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(19);
            make.right.mas_equalTo(-79);
            make.size.mas_equalTo(CGSizeMake(42, 22));
        }];
        
        [self addSubview:self.subBtn];
        [self.subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(16);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(57, 22));
        }];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab=[[UILabel alloc]init];
        _titleLab.font=[UIFont systemFontOfSize:13];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab {
    if (!_subTitleLab) {
        _subTitleLab=[[UILabel alloc]init];
        _subTitleLab.font=[UIFont systemFontOfSize:13];
    }
    return _subTitleLab;
}

- (UIButton *)subBtn {
    if (!_subBtn) {
        _subBtn=[[UIButton alloc]init];
        _subBtn.backgroundColor=[UIColor blackColor];
        [_subBtn setTitle:@"购买" forState:UIControlStateNormal];
        _subBtn.backgroundColor=[UIColor orangeColor];
        _subBtn.layer.cornerRadius=10;
        _subBtn.titleLabel.font=[UIFont systemFontOfSize:13];
    }
    return _subBtn;
}
@end
