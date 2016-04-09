//
//  QiuBaiPostDetailViewController.h
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QiuBaiPost.h"
@interface QiuBaiPostDetailViewController : UITableViewController
- (instancetype)initWithFrame:(CGRect)frame;

@property (strong, nonatomic) QiuBaiPost* post;
@end
