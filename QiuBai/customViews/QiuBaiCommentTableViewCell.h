//
//  QiuBaiCommentTableViewCell.h
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuBaiComment.h"

@interface QiuBaiCommentTableViewCell : UITableViewCell
- (void)setupWith:(QiuBaiComment*)comment;
- (CGFloat)heightWith:(QiuBaiComment*)comment;
@property (strong, nonatomic) UIFont *contentLabelFont;
@end
