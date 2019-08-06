//
//  ETMineVIew.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/19.
//  Copyright © 2019年 EasyTurn. All rights reserved.
//

#import "ETMineVIew.h"
#import "Masonry.h"
#import "WrongSpeakBtn.h"
#import "ETPutViewController.h"
#import "UserMegViewController.h"
#import "UserInfoModel.h"
@implementation ETMineVIew
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.img];
        [self.img addSubview:self.photoImg];
        [self.img addSubview:self.nameLab];
        [self.img addSubview:self.companyLab];
        [self.img addSubview:self.cImg];
        [self.img addSubview:self.signBtn];
        [self.img addSubview:self.putBtn];
        [self addSubview:self.memberv];
        [self addSubview:self.memberi];
        [self addSubview:self.memberLab];
        [self addSubview:self.statusv];
        [self addSubview:self.statusi];
        [self addSubview:self.statusLab];
        [self addSubview:self.meinv];
        [self addSubview:self.meini];
        [self addSubview:self.meinLab];
        [self addSubview:self.accountv];
        [self addSubview:self.accounti];
        [self addSubview:self.accountLab];
        [self addSubview:self.grayView1];
        [self addSubview:self.orangeView];
        [self addSubview:self.surLab];
        [self addSubview:self.numLab];
        [self addSubview:self.speedLab];
        [self addSubview:self.buyBtn];
        [self addSubview:self.grayView2];
        [self addSubview:self.sellBtn];
        [self addSubview:self.giveBtn];
        [self addSubview:self.wantBtn];
        [self addSubview:self.wholeBtn];
        [self addSubview:self.sellBtn];
        [self addSubview:self.giveBtn];
        [self addSubview:self.wantBtn];
        [self addSubview:self.wholeBtn];
        [_img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(33);
            make.left.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.height.mas_equalTo(164);
        }];
        
        [_photoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(48);
            make.left.mas_equalTo(24);
            make.size.mas_equalTo(CGSizeMake(69, 68));
        }];
        _photoImg.layer.masksToBounds = YES;
        _photoImg.layer.cornerRadius = 34;
        
        [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(56);
            make.left.mas_equalTo(109);
            make.size.mas_equalTo(CGSizeMake(113, 22));
        }];
        
        [_companyLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(82);
            make.left.mas_equalTo(109);
            make.size.mas_equalTo(CGSizeMake(106, 19));
        }];
        
        [_cImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(57);
            make.left.mas_equalTo(225);
            make.size.mas_equalTo(CGSizeMake(21, 20));
        }];
        
        [_signBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(73);
            make.left.mas_equalTo(289);
            make.size.mas_equalTo(CGSizeMake(50, 24));
        }];
        
        [_putBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(22, 23));
        }];
        
        [_memberv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(213);
            make.left.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(59, 70));
        }];
        
        [_memberi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(216);
            make.left.mas_equalTo(45);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_memberLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(266);
            make.left.mas_equalTo(35);
            make.size.mas_equalTo(CGSizeMake(60, 21));
        }];
        
        [_statusv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(213);
            make.left.mas_equalTo(117);
            make.size.mas_equalTo(CGSizeMake(59, 70));
        }];
        
        [_statusi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(216);
            make.left.mas_equalTo(127);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(266);
            make.left.mas_equalTo(117);
            make.size.mas_equalTo(CGSizeMake(60, 21));
        }];
        
        [_meinv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(213);
            make.left.mas_equalTo(200);
            make.size.mas_equalTo(CGSizeMake(59, 70));
        }];
        
        [_meini mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(216);
            make.left.mas_equalTo(210);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_meinLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(266);
            make.left.mas_equalTo(200);
            make.size.mas_equalTo(CGSizeMake(60, 21));
        }];
        
        [_accountv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(213);
            make.left.mas_equalTo(282);
            make.size.mas_equalTo(CGSizeMake(59, 70));
        }];
        
        [_accounti mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(216);
            make.left.mas_equalTo(292);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        [_accountLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(266);
            make.left.mas_equalTo(282);
            make.size.mas_equalTo(CGSizeMake(60, 21));
        }];
        
        [_grayView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(313);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(Screen_Width, 10));
        }];
        
        [_orangeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(348);
            make.left.mas_equalTo(40);
            make.size.mas_equalTo(CGSizeMake(82,82));
        }];
        
        [_surLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(374);
            make.left.mas_equalTo(45);
            make.size.mas_equalTo(CGSizeMake(72, 17));
        }];
        
        [_numLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(386);
            make.left.mas_equalTo(74);
            make.size.mas_equalTo(CGSizeMake(14, 33));
        }];
        
        [_speedLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(348);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(195, 38));
        }];
        
        [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(385);
            make.right.mas_equalTo(-15);
            make.size.mas_equalTo(CGSizeMake(195, 35));
        }];
        
        [_grayView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(435);
            make.left.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(Screen_Width, 10));
        }];
        
        [_sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(448);
            make.left.mas_equalTo(45);
            make.size.mas_equalTo(CGSizeMake(32, 22));
        }];
        
        [_giveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(448);
            make.left.mas_equalTo(120);
            make.size.mas_equalTo(CGSizeMake(32, 22));
        }];
        
        [_wantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(448);
            make.right.mas_equalTo(-147);
            make.size.mas_equalTo(CGSizeMake(32, 22));
        }];
        
        [_wholeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(448);
            make.right.mas_equalTo(-44);
            make.size.mas_equalTo(CGSizeMake(65, 22));
        }];
        [self PostUI];
    }
    return self;
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
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:info.name attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        [UserInfoModel saveUserInfoModel:info];
        _nameLab.attributedText = string;
        [_photoImg sd_setImageWithURL:info.portrait];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString: "attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0]}];
//        _companyLab.attributedText = string;
        for (NSDictionary* prod in responseObj[@"data"]) {
//            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
//            [_products addObject:p];
        }
                NSLog(@"");
//        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (UIImageView *)img {
    if (!_img) {
        _img=[[UIImageView alloc]init];
        _img.image=[UIImage imageNamed:@"我的_背景"];
        _img.userInteractionEnabled=YES;
        
    }
    return _img;
}

- (UIImageView *)photoImg {
    if (!_photoImg) {
        _photoImg=[[UIImageView alloc]init];
        _photoImg.image=[UIImage imageNamed:@"我的_Bitmap"];
        _photoImg.userInteractionEnabled=YES;
        UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage:)];
        [_photoImg addGestureRecognizer:singleTap];
    }
    return _photoImg;
}

- (void)onClickImage:(UIImageView*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imgjumpWeb:)]) {
        [self.delegate imgjumpWeb:sender];
    }
}

- (UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab=[[UILabel alloc]init];
        _nameLab.numberOfLines = 0;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"易转用户007"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size:18],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0]}];
        
        _nameLab.attributedText = string;
        _nameLab.textAlignment = NSTextAlignmentLeft;
        _nameLab.alpha = 1.0;
    }
    return _nameLab;
}
- (UILabel *)companyLab {
    if (!_companyLab) {
        _companyLab=[[UILabel alloc]init];
        _companyLab.numberOfLines = 0;
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"北京科技有限公司"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1.0]}];
        _companyLab.attributedText = string;
        _companyLab.textAlignment = NSTextAlignmentLeft;
        _companyLab.alpha = 1.0;
    }
    return _companyLab;
}

- (UIImageView *)cImg {
    if (!_cImg) {
        _cImg=[[UIImageView alloc]init];
        _cImg.image=[UIImage imageNamed:@"我的_企业认证"];
    }
    return _cImg;
}

- (UIButton *)signBtn {
    if (!_signBtn) {
        _signBtn=[[UIButton alloc]init];
        _signBtn.layer.borderWidth=2;
        _signBtn.layer.borderColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor; 
        _signBtn.layer.cornerRadius = 12;
        _signBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
        [_signBtn setTitle:@"已签到" forState:UIControlStateSelected];
        [_signBtn addTarget:self action:@selector(aaa) forControlEvents:UIControlEventTouchUpInside];
    }
    return _signBtn;
}

- (void)aaa {
    if (_signBtn.selected==YES) {
        _signBtn.selected=NO;
         [self PostUI:_signBtn];
    }else {
        _signBtn.selected=YES;
    }
}

- (void)PostUI:(NSString*)head {
    NSDictionary *params = @{
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    
    [HttpTool get:[NSString stringWithFormat:@"user/getInvitationCodeUtilMe"] params:params success:^(NSDictionary *response) {
        NSLog(@"============================成功");
        [_signBtn endEditing:NO];
    } failure:^(NSError *error) {
        NSLog(@"失败");
    }];
    
}

- (UIButton *)putBtn {
    if (!_putBtn) {
        _putBtn=[[UIButton alloc]init];
        [_putBtn setImage:[UIImage imageNamed:@"我的_设置"] forState:UIControlStateNormal];
        [_putBtn addTarget:self action:@selector(putAgreementBtnC:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _putBtn;
}

- (void)putAgreementBtnC:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(putjumpWeb:)]) {
        [self.delegate putjumpWeb:sender];
    }
}


- (UIButton *)memberv {
    if (!_memberv) {
        _memberv=[[UIButton alloc]init];
        [_memberv addTarget:self action:@selector(agreementBtnClick:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _memberv;
}

- (UIImageView *)memberi
{
    if (!_memberi) {
        _memberi=[[UIImageView alloc]init];
        _memberi.image=[UIImage imageNamed:@"我的_分组4"];
    }
    return _memberi;
}

- (UILabel *)memberLab
{
    if (!_memberLab) {
        _memberLab=[[UILabel alloc]init];
        _memberLab.text=@"会员购买";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"会员购买"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        
        _memberLab.attributedText = string;
        _memberLab.textAlignment = NSTextAlignmentLeft;
        _memberLab.alpha = 1.0;
    }
    return _memberLab;
}

- (UIButton *)statusv {
    if (!_statusv) {
        _statusv=[[UIButton alloc]init];
         [_statusv addTarget:self action:@selector(agreementBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _statusv;
}

- (UIImageView *)statusi
{
    if (!_statusi) {
        _statusi=[[UIImageView alloc]init];
        _statusi.image=[UIImage imageNamed:@"我的_分组5"];
    }
    return _statusi;
}

- (UILabel *)statusLab
{
    if (!_statusLab) {
        _statusLab=[[UILabel alloc]init];
        _statusLab.text=@"身份认证";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"身份认证"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        
        _statusLab.attributedText = string;
        _statusLab.textAlignment = NSTextAlignmentLeft;
        _statusLab.alpha = 1.0;
    }
    return _statusLab;
}

- (UIButton *)meinv {
    if (!_meinv) {
        _meinv=[[UIButton alloc]init];
         [_meinv addTarget:self action:@selector(agreementBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _meinv;
}

- (UIImageView *)meini
{
    if (!_meini) {
        _meini=[[UIImageView alloc]init];
        _meini.image=[UIImage imageNamed:@"我的_分组6"];
    }
    return _meini;
}

- (UILabel *)meinLab
{
    if (!_meinLab) {
        _meinLab=[[UILabel alloc]init];
        _meinLab.text=@"我的收藏";
       NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"我的收藏"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        
        _meinLab.attributedText = string;
        _meinLab.textAlignment = NSTextAlignmentLeft;
        _meinLab.alpha = 1.0;
    }
    return _meinLab;
}

- (UIButton *)accountv {
    if (!_accountv) {
        _accountv=[[UIButton alloc]init];
         [_accountv addTarget:self action:@selector(agreementBtnClick3:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountv;
}

- (UIImageView *)accounti
{
    if (!_accounti) {
        _accounti=[[UIImageView alloc]init];
        _accounti.image=[UIImage imageNamed:@"我的_分组7"];
    }
    return _accounti;
}

- (UILabel *)accountLab
{
    if (!_accountLab) {
        _accountLab=[[UILabel alloc]init];
        _accountLab.text=@"账户余额";
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"账户余额"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 15],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        
        _accountLab.attributedText = string;
        _accountLab.textAlignment = NSTextAlignmentLeft;
        _accountLab.alpha = 1.0;
    }
    return _accountLab;
}

- (UIView *)grayView1
{
    if (!_grayView1) {
        _grayView1=[[UIView alloc]init];
        _grayView1.backgroundColor=[UIColor colorWithRed:230/242.0 green:230/242.0 blue:230/242.0 alpha:1.0];
        
    }
    return _grayView1;
}

- (UIView *)orangeView
{
    if (!_orangeView) {
        _orangeView=[[UIView alloc]init];
        _orangeView.layer.borderWidth = 4;
        _orangeView.layer.cornerRadius=41;
        _orangeView.layer.borderColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:43/255.0 alpha:1.0].CGColor;
        
        _orangeView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    }
    return _orangeView;
}

- (UILabel *)surLab
{
    if (!_surLab) {
        _surLab=[[UILabel alloc]init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"剩余刷新次数"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 12],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
        
        _surLab.attributedText = string;
        _surLab.textAlignment = NSTextAlignmentLeft;
        _surLab.alpha = 1.0;
    }
    return _surLab;
}

- (UILabel *)numLab
{
    if (!_numLab) {
        _numLab=[[UILabel alloc]init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"3"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium" size: 23],NSForegroundColorAttributeName: [UIColor colorWithRed:82/255.0 green:74/255.0 blue:3/255.0 alpha:1.0]}];
        
        _numLab.attributedText = string;
        _numLab.textAlignment = NSTextAlignmentLeft;
        _numLab.alpha = 1.0;
    }
    return _numLab;
}

- (UILabel *)speedLab
{
    if (!_speedLab) {
        _speedLab=[[UILabel alloc]init];
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"每次刷新，您的商品都会更改排名提高曝光次数，提升卖出速度。"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13],NSForegroundColorAttributeName: [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]}];
                                             
                                             _speedLab.attributedText = string;
                                             _speedLab.textAlignment = NSTextAlignmentLeft;
                                             _speedLab.alpha = 1.0;
        _speedLab.numberOfLines = 0;
    }
    return _speedLab;
}
-(UIButton *)buyBtn
{
    if (!_buyBtn) {
        _buyBtn=[[UIButton alloc]init];
        _buyBtn.layer.backgroundColor = [UIColor colorWithRed:248/255.0 green:124/255.0 blue:43/255.0 alpha:1.0].CGColor;
        _buyBtn.layer.cornerRadius = 18;
        [_buyBtn setTitle:@"购买刷新次数" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font=[UIFont systemFontOfSize:15];
         [_buyBtn addTarget:self action:@selector(agreementBtnClick4:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _buyBtn;
}

- (UIView *)grayView2 {
    if (!_grayView2) {
        _grayView2=[[UIView alloc]init];
        _grayView2.backgroundColor=[UIColor colorWithRed:230/242.0 green:230/242.0 blue:230/242.0 alpha:1.0];
        
        
    }
    return _grayView2;
}
- (UIButton *)sellBtn {
    if (!_sellBtn) {
        _sellBtn=[[UIButton alloc]init];
        _sellBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_sellBtn setTitle:@"出售" forState:UIControlStateNormal];
        [_sellBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sellBtn addTarget:self action:@selector(a:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellBtn;
}

- (UIButton *)giveBtn {
    if (!_giveBtn) {
        _giveBtn=[[UIButton alloc]init];
        _giveBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_giveBtn setTitle:@"服务" forState:UIControlStateNormal];
        [_giveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_giveBtn addTarget:self action:@selector(a:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _giveBtn;
}

- (UIButton *)wantBtn {
    if (!_wantBtn) {
        _wantBtn=[[UIButton alloc]init];
        _wantBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_wantBtn setTitle:@"求购" forState:UIControlStateNormal];
        [_wantBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wantBtn addTarget:self action:@selector(a:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wantBtn;
}

- (UIButton *)wholeBtn {
    if (!_wholeBtn) {
        _wholeBtn=[[UIButton alloc]init];
        _wholeBtn.titleLabel.font=[UIFont systemFontOfSize:15];
        [_wholeBtn setTitle:@"全部订单" forState:UIControlStateNormal];
        [_wholeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_wholeBtn addTarget:self action:@selector(a:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wholeBtn;
}

-(void)a:(UIButton*)sender {
    WrongSpeakBtn*btn=[[WrongSpeakBtn alloc]init];
    [btn setQJselected:NO];
    [btn layoutSubviews];
    if ([sender.titleLabel.text isEqualToString:@"出售"]) {
        if (self.block) {
            self.block(@"1");
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"服务"]) {
        if (self.block) {
            self.block(@"2");
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"求购"]) {
        if (self.block) {
            self.block(@"3");
        }
    }
    if ([sender.titleLabel.text isEqualToString:@"全部订单"]) {
        if (self.block) {
            self.block(@"");
        }
    }
    
    
}

- (void)agreementBtnClick:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWebVC:)]) {
        [self.delegate jumpWebVC:sender];
    }
}

- (void)agreementBtnClick1:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWebVC1:)]) {
        [self.delegate jumpWebVC1:sender];
    }
}

- (void)agreementBtnClick2:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWebVC2:)]) {
        [self.delegate jumpWebVC2:sender];
    }
}

- (void)agreementBtnClick3:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWebVC3:)]) {
        [self.delegate jumpWebVC3:sender];
    }
}

- (void)agreementBtnClick4:(UIButton*)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpWebVC4:)]) {
        [self.delegate jumpWebVC4:sender];
    }
}
@end
