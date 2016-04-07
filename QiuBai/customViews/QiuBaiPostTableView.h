//
//  QiuBaiPostTableView.h
//  QiuBai
//
//  Created by PengPremium on 16/3/31.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QiuBaiPostTableViewCell;
@class QiuBaiPost;
@interface QiuBaiPostTableView : UITableView
- (CGFloat)tableViewCellHeightWithPost:(QiuBaiPost*)post;
- (QiuBaiPostTableViewCell*)tableViewCellWithPost:(QiuBaiPost*)post;
@end
