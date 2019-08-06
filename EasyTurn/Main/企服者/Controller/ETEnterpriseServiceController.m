//
//  ETEnterpriseServiceController.m
//  EasyTurn
//
//  Created by 程立 on 2019/7/18.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETEnterpriseServiceController.h"
#import "ETBusinessViewController.h"
#import "ETTaxationViewController.h"
#import "ETAdministrationViewController.h"
#import "ETFinancialViewController.h"
#import "ETIntelligenceViewController.h"
#import "ETPuzzleViewController.h"
@interface ETEnterpriseServiceController ()

@property(nonatomic,strong) UIImageView *businessImg;
@property(nonatomic,strong) UIButton *businessBtn;
@property(nonatomic,strong) UIImageView *taxationImg;
@property(nonatomic,strong) UIButton *taxationBtn;
@property(nonatomic,strong) UIImageView *administrationImg;
@property(nonatomic,strong) UIButton *administrationBtn;
@property(nonatomic,strong) UIImageView *financialImg;
@property(nonatomic,strong) UIButton *financialBtn;
@property(nonatomic,strong) UIImageView *intelligenceImg;
@property(nonatomic,strong) UIButton *intelligenceBtn;
@property(nonatomic,strong) UIImageView *puzzleImg;
@property(nonatomic,strong) UIButton *puzzleBtn;
@end

@implementation ETEnterpriseServiceController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"企服者";
    self.view.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    [self.businessBtn addSubview:self.businessImg];
    [self.view addSubview:self.businessBtn];
    [self.taxationBtn addSubview:self.taxationImg];
    [self.view addSubview:self.taxationBtn];
    [self.administrationBtn addSubview:self.administrationImg];
    [self.view addSubview:self.administrationBtn];
    [self.financialBtn addSubview:self.financialImg];
    [self.view addSubview:self.financialBtn];
    [self.intelligenceBtn addSubview:self.intelligenceImg];
    [self.view addSubview:self.intelligenceBtn];
    [self.puzzleBtn addSubview:self.puzzleImg];
    [self.view addSubview:self.puzzleBtn];
    
    [_businessImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(76);
    }];
    
    [_businessBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51);
        make.left.mas_equalTo(46);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    [_taxationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(76);
    }];
    
    [_taxationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(51);
        make.right.mas_equalTo(-45);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    [_administrationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(71);
    }];
    
    [_administrationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(207);
        make.left.mas_equalTo(46);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    [_financialImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(71);
    }];
    
    [_financialBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(207);
        make.right.mas_equalTo(-45);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    
    [_intelligenceImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(76);
    }];
    
    [_intelligenceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(363);
        make.left.mas_equalTo(46);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    [_puzzleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(26);
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(76);
    }];
    
    [_puzzleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(363);
        make.right.mas_equalTo(-45);
        make.size.mas_equalTo(CGSizeMake(128, 128));
    }];
    
    
}

- (UIImageView *)businessImg {
    if (!_businessImg) {
        _businessImg=[[UIImageView alloc]init];
        _businessImg.image=[UIImage imageNamed:@"企服者_分组 2"];
    }
    return _businessImg;
}

- (UIButton *)businessBtn {
    if (!_businessBtn) {
        _businessBtn=[[UIButton alloc]init];
        _businessBtn.layer.cornerRadius=10;
        _businessBtn.backgroundColor=[UIColor whiteColor];
        [_businessBtn addTarget:self action:@selector(businessTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _businessBtn;
}

- (void)businessTouch {
    [self.navigationController pushViewController:[[ETBusinessViewController alloc]init] animated:YES];
}
- (UIImageView *)taxationImg {
    if (!_taxationImg) {
        _taxationImg=[[UIImageView alloc]init];
        _taxationImg.image=[UIImage imageNamed:@"企服者_分组 3"];
    }
    return _taxationImg;
}

- (UIButton *)taxationBtn {
    if (!_taxationBtn) {
        _taxationBtn=[[UIButton alloc]init];
        _taxationBtn.layer.cornerRadius=10;
        _taxationBtn.backgroundColor=[UIColor whiteColor];
        [_taxationBtn addTarget:self action:@selector(taxationTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _taxationBtn;
}

- (void)taxationTouch {
    ETTaxationViewController*taxVC=[[ETTaxationViewController alloc]init];
    [self.navigationController pushViewController:taxVC animated:YES];
}

- (UIImageView *)administrationImg {
    if (!_administrationImg) {
        _administrationImg=[[UIImageView alloc]init];
        _administrationImg.image=[UIImage imageNamed:@"企服者_分组 4"];
    }
    return _administrationImg;
}

- (UIButton *)administrationBtn {
    if (!_administrationBtn) {
        _administrationBtn=[[UIButton alloc]init];
        _administrationBtn.layer.cornerRadius=10;
        _administrationBtn.backgroundColor=[UIColor whiteColor];
        [_administrationBtn addTarget:self action:@selector(administrationTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _administrationBtn;
}

- (void)administrationTouch {
    ETAdministrationViewController*admVC=[[ETAdministrationViewController alloc]init];
    [self.navigationController pushViewController:admVC animated:YES];
}
- (UIImageView *)financialImg {
    if (!_financialImg) {
        _financialImg=[[UIImageView alloc]init];
        _financialImg.image=[UIImage imageNamed:@"企服者_分组 5"];
    }
    return _financialImg;
}

- (UIButton *)financialBtn {
    if (!_financialBtn) {
        _financialBtn=[[UIButton alloc]init];
        _financialBtn.layer.cornerRadius=10;
        _financialBtn.backgroundColor=[UIColor whiteColor];
        [_financialBtn addTarget:self action:@selector(financialTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _financialBtn;
}

- (void)financialTouch {
    ETFinancialViewController*finVC=[[ETFinancialViewController alloc]init];
    [self.navigationController pushViewController:finVC animated:YES];
}
- (UIImageView *)intelligenceImg {
    if (!_intelligenceImg) {
        _intelligenceImg=[[UIImageView alloc]init];
        _intelligenceImg.image=[UIImage imageNamed:@"企服者_分组 6"];
    }
    return _intelligenceImg;
}

- (UIButton *)intelligenceBtn {
    if (!_intelligenceBtn) {
        _intelligenceBtn=[[UIButton alloc]init];
        _intelligenceBtn.layer.cornerRadius=10;
        _intelligenceBtn.backgroundColor=[UIColor whiteColor];
        [_intelligenceBtn addTarget:self action:@selector(intelligenceTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _intelligenceBtn;
}

- (void)intelligenceTouch {
    ETIntelligenceViewController*intVC=[[ETIntelligenceViewController alloc]init];
    [self.navigationController pushViewController:intVC animated:YES];
}

- (UIImageView *)puzzleImg {
    if (!_puzzleImg) {
        _puzzleImg=[[UIImageView alloc]init];
        _puzzleImg.image=[UIImage imageNamed:@"企服者_分组 7"];
    }
    return _puzzleImg;
}

- (UIButton *)puzzleBtn {
    if (!_puzzleBtn) {
        _puzzleBtn=[[UIButton alloc]init];
        _puzzleBtn.layer.cornerRadius=10;
        _puzzleBtn.backgroundColor=[UIColor whiteColor];
        [_puzzleBtn addTarget:self action:@selector(puzzleTouch) forControlEvents:UIControlEventTouchUpInside];
    }
    return _puzzleBtn;
}

- (void)puzzleTouch {
    ETPuzzleViewController*puzVC=[[ETPuzzleViewController alloc]init];
    [self.navigationController pushViewController:puzVC animated:YES];
}
@end
