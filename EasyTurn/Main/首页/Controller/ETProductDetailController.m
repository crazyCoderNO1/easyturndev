//
//  ETProductDetailController.m
//  EasyTurn
//
//  Created by 程立 on 2019/7/29.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETProductDetailController.h"
#import "ProductInfoCell.h"
#import "SDCycleScrollView.h"
#import "ETProductModel.h"
#import "ETBuyPushViewController.h"
#import "WXApiManagerShare.h"

static NSString* const kShareButtonText = @"分享  ";
static NSString* const kShareDescText = @"分享一个链接";
static NSString* const kShareFailedText = @"分享失败";
@interface ETProductDetailController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (nonatomic, strong) UIView *bigView;
@property (nonatomic, strong) UIWebView *webView;

//添加在头部视图的tempScrollView
@property (nonatomic, strong) UIScrollView *tempScrollView;
//记录底部空间所需的高度
@property (nonatomic, assign) CGFloat bottomHeight;
@property (nonatomic, strong) NSArray *detailTitles;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
///轮播图数组
@property (nonatomic, strong) NSArray *imageGroupArray;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) NSMutableArray *products;
@property (nonatomic, assign) CGFloat labelHeight;
@end

@implementation ETProductDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self enableLeftBackButton];
    [self setBgUI];
    [self setHeaderAndFooterView];
    [self setBottomView];
    [self setUpLeftTwoButton];
    self.title=@"test";
    
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width/2, TopHeight)];
    _navigationView.backgroundColor = kACColorClear;
    [self.view addSubview:_navigationView];
    _leftButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    _leftButton.frame = CGRectMake(15, StatusBarHeight, 55, 45);
    //    [_leftButton setBackgroundColor:[UIColor blueColor]];
    [_leftButton setImage:[UIImage imageNamed:@"navigation_back_hl"] forState:(UIControlStateNormal)];
    [_leftButton addTarget:self action:@selector(backAction) forControlEvents:(UIControlEventTouchUpInside)];
    [_navigationView addSubview:_leftButton];
    // Do any additional setup after loading the view.
    [self PostUI];
}
#pragma mark - 动态列表
- (void)PostUI {
    NSMutableDictionary* dic=[NSMutableDictionary new];
    NSDictionary *params = @{
                             @"releaseId" : _releaseId
                             };
    [HttpTool get:[NSString stringWithFormat:@"release/releaseDetail"] params:params success:^(id responseObj) {
        _products=[NSMutableArray new];
        NSDictionary* a=responseObj[@"data"];
        for (NSDictionary* prod in responseObj[@"data"]) {
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:prod];
//            [_products addObject:p];
        }
        //        NSLog(@"");
            ETProductModel* p=[ETProductModel mj_objectWithKeyValues:a];
        //
        NSMutableArray* imgs=[NSMutableArray new];
        if (p.imageList) {
            [imgs addObject:p.imageList];
        }
        self.imageGroupArray=imgs;
        //
        NSString *str = [NSString string];
        _labelHeight = [p.business boundingRectWithSize:CGSizeMake(Screen_Width, MAXFLOAT)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                        context:nil].size.height;
            NSLog(@"");
        [_products addObject:p];
        [_tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setBgUI
{
    _bottomHeight = 40;
    
    //存放tableView和webView，tableview在上面，webview在下面
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _bigView.backgroundColor = kACColorWhite;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, Screen_Height)];
    _tableView.backgroundColor = kACColorWhite;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"ProductInfoCell" bundle:nil] forCellReuseIdentifier:@"productinfocell"];
    //去掉顶部偏移
    if (@available(iOS 11.0, *))
    {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    [self.view addSubview:_bigView];
    [_bigView addSubview:_tableView];
    
    
}

- (void)setHeaderAndFooterView{
    
    //添加头部和尾部视图
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 218)];
    headerView.backgroundColor = kACColorWhite;
    
    _tempScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 218)];
    [headerView addSubview:_tempScrollView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 218)];
    _headerImageView.contentMode = UIViewContentModeScaleAspectFit;
    _headerImageView.image = _image;
//    [_tempScrollView addSubview:_headerImageView];
    
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, Screen_Width, 218) delegate:self placeholderImage:nil];
    _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _cycleScrollView.autoScrollTimeInterval = 5.0;
    [_tempScrollView addSubview:_cycleScrollView];
//    [_cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(218);
//    }];
    //
    
    UIButton* share=[UIButton new];
    [share setBackgroundImage:[UIImage imageNamed:@"详情_分组8"] forState:UIControlStateNormal];
    [_cycleScrollView addSubview:share];
    [share addTarget:self action:@selector(shareBtn) forControlEvents:UIControlEventTouchUpInside];
    [share mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12+22);
        make.right.mas_equalTo(-12);
        make.width.height.mas_equalTo(25);
    }];
    
    UIButton* fav=[UIButton new];
    [fav setBackgroundImage:[UIImage imageNamed:@"详情_分组13"] forState:UIControlStateNormal];
    [_cycleScrollView addSubview:fav];
    [fav addTarget:self action:@selector(fav) forControlEvents:UIControlEventTouchUpInside];
    [fav mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12+22);
        make.right.mas_equalTo(-12-25-9);
        make.width.height.mas_equalTo(25);
    }];
    
    _tableView.tableHeaderView = headerView;
    
    NSArray* imgs=@[@"https://yizhuanvip.oss-cn-beijing.aliyuncs.com/banner/a6c0631bb287b8a59a3264ec9e13258.jpg",@"https://yizhuanvip.oss-cn-beijing.aliyuncs.com/banner/b98137ff7fb5f6a2a23de55d9607d59.jpg"];
    self.imageGroupArray=imgs;
    
    UILabel *pullMsgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    pullMsgView.textAlignment = NSTextAlignmentCenter;
    pullMsgView.text = @"上拉显示网页";
    pullMsgView.textColor = kACColorBlack;
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    [footView addSubview:pullMsgView];
    
//    _tableView.tableFooterView = footView;
    
    //设置下拉提示视图
    UILabel *downPullMsgView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Screen_Width, 40)];
    downPullMsgView.textAlignment = NSTextAlignmentCenter;
    downPullMsgView.text = @"下拉显示列表";
    downPullMsgView.textColor = kACColorBlack;
    
    UIView *downMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, -40, Screen_Width, 40)];
    [downMsgView addSubview:downPullMsgView];
    [_webView.scrollView addSubview:downMsgView];
}

- (void)setBottomView
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_Height - _bottomHeight, Screen_Width, _bottomHeight)];
    _bottomView.backgroundColor = kACColorBackgroundGray;
    _tableView.tableFooterView=_bottomView;
    
    UIButton *addButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addButton.frame = CGRectMake(_bottomView.mj_w/2, 0, _bottomView.mj_w/4, _bottomHeight);
    addButton.backgroundColor = RGBCOLOR(60, 138, 239);
    addButton.titleLabel.font = SYSTEMFONT(16);
    [addButton setTitle:@"联系人:张先生" forState:(UIControlStateNormal)];
    [addButton setTitleColor:kACColorWhite forState:(UIControlStateNormal)];
    addButton.tag=0;
    [addButton addTarget:self action:@selector(addAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView addSubview:addButton];
    
    UIButton *addimButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    addimButton.frame = CGRectMake(_bottomView.mj_w*3/4, 0, _bottomView.mj_w/4, _bottomHeight);
    addimButton.backgroundColor = RGBCOLOR(60, 138, 239);
    addimButton.titleLabel.font = SYSTEMFONT(16);
    [addimButton setTitle:@"联系商家" forState:(UIControlStateNormal)];
    [addimButton setTitleColor:kACColorWhite forState:(UIControlStateNormal)];
    addimButton.tag=1;
    [addimButton addTarget:self action:@selector(shareBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [_bottomView addSubview:addimButton];
    
}
-(void)addAction:(id)sender
{
    ETProductModel* p=[_products objectAtIndex:0];
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:p.userId conversationType:EMConversationTypeChat];
    [self.navigationController pushViewController:chatController animated:YES];
}
#pragma mark - 收藏 购物车
- (void)setUpLeftTwoButton
{
    NSArray *imagesNor = @[@"tabr_07shoucang_up",@"ptgd_icon_xiaoxi",@"tabr_08gouwuche"];
    NSArray *imagesSel = @[@"tabr_07shoucang_down",@"ptgd_icon_xiaoxi",@"tabr_08gouwuche"];
    CGFloat buttonW = Screen_Width * 0.15;
    CGFloat buttonH = _bottomHeight;
    CGFloat buttonY = Screen_Height - buttonH;
    
    for (NSInteger i = 0; i < imagesNor.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:imagesNor[i]] forState:UIControlStateNormal];
        button.backgroundColor = kACColorBackgroundGray;
        [button setImage:[UIImage imageNamed:imagesSel[i]] forState:UIControlStateSelected];
        button.tag = i;
        [button addTarget:self action:@selector(bottomButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat buttonX = (buttonW * i);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
//        [self.view addSubview:button];
    }
}
- (void)setImageGroupArray:(NSArray *)imageGroupArray{
    _imageGroupArray = imageGroupArray;
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"首页_轮播占位图"];
    if (imageGroupArray.count == 0) return;
    _cycleScrollView.imageURLStringsGroup = _imageGroupArray;
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;

    if (scrollView == _tableView){
        //重新赋值，就不会有用力拖拽时的回弹
//        _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, 0);
        if (offset >= TopHeight && offset <= Screen_Width) {
            _leftButton.hidden=YES; //因为tempScrollView是放在tableView上的，tableView向上速度为1，实际上tempScrollView的速度也是1，此处往反方向走1/2的速度，相当于tableView还是正向在走1/2，这样就形成了视觉差！
//            _tempScrollView.contentOffset = CGPointMake(_tempScrollView.contentOffset.x, - offset / 2.0f);
        }
        else
            _leftButton.hidden=NO;
    }

}
//
//#pragma mark -- 监听滚动实现商品详情与图文详情界面的切换
//-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    WeakSelf(self);
//    CGFloat offset = scrollView.contentOffset.y;
//    if (scrollView == _tableView) {
//        if (offset > _tableView.contentSize.height - Screen_Height + self.bottomHeight + 50) {
//            [UIView animateWithDuration:0.4 animations:^{
//                weakself.bigView.transform = CGAffineTransformTranslate(weakself.bigView.transform, 0, -Screen_Height +  self.bottomHeight + TopHeight);
//            } completion:^(BOOL finished) {
//
//            }];
//        }
//        //        [_basecontroller.segmentedControl didSelectIndex:1];
//    }
//    if (scrollView == _webView.scrollView) {
//        if (offset < -50) {
//            [UIView animateWithDuration:0.4 animations:^{
//                [UIView animateWithDuration:0.4 animations:^{
//                    weakself.bigView.transform = CGAffineTransformIdentity;
//
//                }];
//            } completion:^(BOOL finished) {
//
//            }];
//        }
//        //        [_basecontroller.segmentedControl didSelectIndex:1];
//
//    }
//}

#pragma mark -- UITableViewDelegate & dataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==1)
        return 1;
    else if(section==3)
        return 3;
    else if(section==4)
        return 2;
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 100;
    }
    else if (indexPath.section==1&&indexPath.row!=0){
        return 80;
    }
    else if (indexPath.section==1&&indexPath.row==0){
        return 40;
    }
    else if (indexPath.section==2) {
        if (_labelHeight) {
            return _labelHeight+63;
        }
        else
            return 80;
    }
    else if (indexPath.section==4) {
        if (indexPath.row==0) {
            return 80;
        }
        else{
        return 160;
        }
    }
    else{
        
        return 60;
    }
}
//设置分区尾视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section>0) {
        if (section==5) {
            return 0.01;
        }
        else
            return 10;
    }
    else{
        return 0.01;
    }
}
//设置分区头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0.01;
}
//设置分区的尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 10)];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    
    //    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    //    if (!cell) {
    UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    }
    
    cell.textLabel.font = SYSTEMFONT(16);
    cell.textLabel.textColor = kACColorBlack;
    cell.textLabel.text = [_detailTitles objectAtIndex:indexPath.row+indexPath.section];
    if (indexPath.section==0) {
        ProductInfoCell *cell=[_tableView dequeueReusableCellWithIdentifier:@"productinfocell"];
        cell.titleLabel.text=@"代理公司记账";
        cell.titleLabel.numberOfLines=0;
        //
        ETProductModel* p=[_products objectAtIndex:0];
        cell.priceLabel.text=[NSString stringWithFormat:@"￥:%@",p.price];
        cell.oPriceLabel.text=[NSString stringWithFormat:@"价格:￥%@",@""];
        [cell.tradeBtn addTarget:self action:@selector(tiao) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section==2) {
        cell.textLabel.text=@"经营范围";
        cell.detailTextLabel.numberOfLines=0;
        cell.detailTextLabel.text=@"转让北京现成资质14项房建总包三级，市政";
        ETProductModel* p=[_products objectAtIndex:0];
        cell.detailTextLabel.text=p.business;
    }
    if (indexPath.section==3) {
        cell.textLabel.text=@"注册时间";
        cell.detailTextLabel.text=@"2019-06-19";
        ETProductModel* p=[_products objectAtIndex:0];
        if (indexPath.row==1) {
            cell.textLabel.text=@"注册地址";
            cell.detailTextLabel.text=@"2019-06-19";
            cell.detailTextLabel.text=p.cityName;
        }
        if (indexPath.row==2) {
            cell.textLabel.text=@"纳税类型";
            cell.detailTextLabel.text=@"2019-06-19";
            if ([p.taxId isEqualToString:@"0"]) {
                cell.detailTextLabel.text=@"小规模";
            }
            if ([p.taxId isEqualToString:@"1"]) {
                cell.detailTextLabel.text=@"中规模";
            }
            if ([p.taxId isEqualToString:@"2"]) {
                cell.detailTextLabel.text=@"大规模";
            }
        }
    }
    if (indexPath.section==4&&indexPath.row==0) {
        cell.textLabel.text=@"附带资产";
        cell.detailTextLabel.text=@"免费送建造师带安全";
    }
    if (indexPath.section==4&&indexPath.row==1) {
        cell.textLabel.text=@"其他信息";
        cell.detailTextLabel.text=@"我们单位现在有多家现成资质转让可以量身定";
    }
    if (indexPath.section==5) {
        cell.imageView.image=[UIImage imageNamed:@"我的_Bitmap"];
        cell.textLabel.text=@"易转平台";
        cell.detailTextLabel.text=@"推荐一条新的收购";
    }
//    if(indexPath.section==1&&indexPath.row==0){
//        UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
//        UIButton* b=[UIButton new];
//        [b setTitle:[NSString stringWithFormat:@"商品评论(%d)",_commentList.count] forState:UIControlStateNormal];
//        [b setFont:[UIFont systemFontOfSize:13]];
//        [b setTitleColor:KDarkTextColor forState:(UIControlStateNormal)];
//        [b addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
//        [v addSubview:b];
//        [cell.contentView addSubview:v];
//
//        [b mas_makeConstraints:^(MASConstraintMaker *make) {
//            [make.centerY.mas_equalTo(cell.contentView)setOffset:(0)];
//            [make.left.mas_equalTo(cell.contentView)setOffset:(-5)];
//            make.size.mas_equalTo(CGSizeMake(120, 40));
//        }];
//        cell.textLabel.text=@"";
//        return cell;
//    }
//    if (indexPath.section==1&&indexPath.row==1&&_commentList.count>0) {
//        UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
//        UILabel*comName=[UILabel new];
//        StarView* star=[StarView new];
//        UILabel* date=[UILabel new];
//        UILabel* comm=[UILabel new];
//
//        cell.textLabel.text=@"";
//        return cell;
//    }
//    else if(indexPath.section==1&&indexPath.row==2){
//        UIView* v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 80)];
//        UIButton* b=[UIButton new];
//        [b setTitle:@"查看更多评论" forState:UIControlStateNormal];
//        [b setTitleColor:[UIColor redColor] forState:(UIControlStateNormal)];
//        [b addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
//        [v addSubview:b];
//        [cell.contentView addSubview:v];
//
//        [b mas_makeConstraints:^(MASConstraintMaker *make) {
//            [make.center.mas_equalTo(cell.contentView)setOffset:(0)];
//            make.size.mas_equalTo(CGSizeMake(120, 40));
//        }];
//        cell.textLabel.text=@"";
//        return cell;
//    }
//    else if (indexPath.section==2)
//    {
//        cell.detailTextLabel.text=_pmodel.detailInfo;
//        return cell;
//    }
    return cell;
}

- (void)tiao {
    ETBuyPushViewController *buy =[[ETBuyPushViewController alloc]init];
    buy.product=_products[0];
    ETProductModel* p=_products[0];
    buy.releaseId=p.releaseId;
    [self.navigationController pushViewController:buy animated:YES];
    
}
-(void)share
{
    UIImage *image = [UIImage imageNamed:@"res2.png"];
    UIImage* imageData = UIImageJPEGRepresentation(image, 0.7);
    
    WXImageObject *imageObject = [WXImageObject object];
    imageObject.imageData = imageData;
    
    WXMediaMessage *message = [WXMediaMessage message];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"res5"
                                                         ofType:@"jpg"];
    message.thumbData = [NSData dataWithContentsOfFile:filePath];
    message.mediaObject = imageObject;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}
//分享微信方法
-(void)shareBtn
{
    
    [[[UIActionSheet alloc] initWithTitle:@"分享到微信"
                                 delegate:self
                        cancelButtonTitle:@"取消"
                   destructiveButtonTitle:nil
                        otherButtonTitles:@"转发到会话", @"分享到朋友圈", nil] showInView:self.view];
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: // 转发到会话
            [[WXApiManagerShare sharedManager] sendLinkContent:[[NSURL URLWithString:@"www.baidu.com"] absoluteString]
                                                    Title:self.title
                                              Description:kShareDescText
                                                  AtScene:WXSceneSession];
            break;
        case 1: //分享到朋友圈
            [[WXApiManagerShare sharedManager] sendLinkContent:[[NSURL URLWithString:@"www.baidu.com"] absoluteString]
                                                    Title:self.title
                                              Description:kShareDescText
                                                  AtScene:WXSceneTimeline];
            break;
        default:
            break;
    }
}
#pragma mark - 添加收藏
-(void)fav:(UIButton*)sender
{
    if(sender.selected)
        [self delfav];
    else{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    long long a=[_releaseId longLongValue];
    NSDictionary *params = @{
                             @"releaseId" : @(a)
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    
    [HttpTool put:[NSString stringWithFormat:@"collect/myAdd"] params:params success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
    }];
    }
    sender.selected=!sender.selected;
}

#pragma mark - 删除收藏
-(void)delfav
{
    NSMutableDictionary* dic=[NSMutableDictionary new];
    int a=[_releaseId doubleValue];
    NSDictionary *params = @{
                             @"releaseId" : @(a)
                             };
    NSData *data =    [NSJSONSerialization dataWithJSONObject:params options:NSUTF8StringEncoding error:nil];
    
    [HttpTool put:[NSString stringWithFormat:@"collect/myDel"] params:params success:^(NSDictionary *response) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"");
    } failure:^(NSError *error) {
        NSLog(@"");
        
    }];
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        ETBuyPushViewController *buy =[[ETBuyPushViewController alloc]init];
//        [self.navigationController pushViewController:buy animated:YES];
//    }
//}
@end
