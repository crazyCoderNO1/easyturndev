//
//  ETProductModel.h
//  EasyTurn
//
//  Created by 程立 on 2019/7/28.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "UserInfoModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ETProductModel : NSObject
@property (nonatomic, copy) NSString *baesId;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *management;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *auth;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;
@property (nonatomic, copy) NSString *share;
@property (nonatomic, copy) NSString *imageList;
@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *business;
@property (nonatomic, copy) NSString *releaseId;
@property (nonatomic, copy) NSString *detail;
@property (nonatomic, copy) NSString *releaseTime;
@property (nonatomic, copy) NSString *releaseTypeId;
@property (nonatomic, copy) NSString *serviceId;
@property (nonatomic, copy) NSString *taxId;

//详情
@property (nonatomic, copy) NSString *userId;


//详情
@property (nonatomic, strong) UserInfoModel *userInfo;

@end

NS_ASSUME_NONNULL_END
