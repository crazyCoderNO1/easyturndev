//
//  ETPaymentStatesCell.h
//  EasyTurn
//
//  Created by 刘盖 on 2019/8/5.
//  Copyright © 2019 EasyTurn. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ETPaymentStatesCell : UITableViewCell

+ (CGFloat)cellHeight;

+ (instancetype)paymentStatesCell:(UITableView *)tableView title:(NSString *)title sub:(NSString *)sub indexPath:(NSIndexPath *)indexPath;

@end

@interface ETPaymentStatesPriceCell : UITableViewCell

+ (CGFloat)cellHeight;

+ (instancetype)paymentStatesPriceCell:(UITableView *)tableView price:(NSString *)price indexPath:(NSIndexPath *)indexPath total:(NSInteger)total;

@end

NS_ASSUME_NONNULL_END
