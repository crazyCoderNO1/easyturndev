//
//  ETReleaseViewController.m
//  EasyTurn
//
//  Created by 程立 on 2019/7/18.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import "ETReleaseViewController.h"
#import "ETHomeViewController.h"
#import "ETRKongViewController.h"
@interface ETReleaseViewController ()

@end
@implementation ETReleaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
//    ETRKongViewController*et=[[ETRKongViewController alloc]init];
//    UIImage *image = [self imageWithCaputureView:self.view];
//    et.backImg = image;
//    [self presentViewController:et animated:NO completion:nil];
}

- (UIImage *)imageWithCaputureView:(UIView *)view
{
    CGSize size = CGSizeMake(view.bounds.size.width, view.bounds.size.height*0.9);
    
    // 开启位图上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 把控件上的图层渲染到上下文,layer只能渲染
    [view.layer renderInContext:ctx];
    
    // 生成新图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return image;
}

@end
