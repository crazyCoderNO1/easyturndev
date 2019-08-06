//
//  ETPublishPurchaseViewController.m
//  EasyTurn
//
//  Created by 王翔 on 2019/7/30.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETPublishPurchaseViewController.h"
#import "YHDetailsTabController.h"
#import "YHSegmentView.h"
@interface ETPublishPurchaseViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UISegmentedControl *segment;
@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITableView *tableView1;
@property (nonatomic,strong)UITableView *tableView2;
@end

@implementation ETPublishPurchaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"发布求购";
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
//    [self firstBtn1];
    NSMutableArray *mutArr = [NSMutableArray array];
    NSArray *titleArr = @[@"企业流转",@"企业服务"];
    for (int i = 0; i < 2; i++) {
        YHDetailsTabController *tabVC = [YHDetailsTabController new];
        tabVC.title = titleArr[i];
        [mutArr addObject:tabVC];
    }
    
    YHSegmentView *segmentView = [[YHSegmentView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, [UIScreen mainScreen].bounds.size.height - CGRectGetMaxY(self.navigationController.navigationBar.frame)) ViewControllersArr:[mutArr copy] TitleArr:titleArr TitleNormalSize:20 TitleSelectedSize:20 SegmentStyle:YHSegementStyleSpace ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
        NSLog(@"点击了%ld模块",(long)index);
    }];
    [self.view addSubview:segmentView];
    
    //添加取消按钮->
    [self addCancelBtn];
}

//添加取消按钮->
-(void)addCancelBtn{
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"nav_leftBack"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick)];
    self.navigationItem.leftBarButtonItem = backBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)firstBtn1 {
//    NSArray *array = [NSArray arrayWithObjects:@"企业流转",@"企业服务", nil];
//    //初始化UISegmentedControl
//    _segment.backgroundColor=[UIColor whiteColor];
//    _segment.selectedSegmentIndex=1;
//    _segment = [[UISegmentedControl alloc]initWithItems:array];
//    //添加到视图
//    [self.view addSubview:_segment];
//    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(10);
//        make.left.mas_equalTo(86);
//        make.right.mas_equalTo(-86);
//        make.height.mas_equalTo(39);
//    }];
//    [_segment addTarget:self action:@selector(change:) forControlEvents:UIControlEventValueChanged];
//}
//-(void)change:(UISegmentedControl *)sender{
//    NSLog(@"测试");
//    if (sender.selectedSegmentIndex == 0) {
//        NSLog(@"1");
//
//    }else if (sender.selectedSegmentIndex == 1){
//        NSLog(@"2");
//    }
//}


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

@end
