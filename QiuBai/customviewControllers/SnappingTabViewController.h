//
//  SnappingTabViewController.h
//  QiuBai
//
//  Created by PengPremium on 16/3/30.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SnappingTabViewDataSource.h"
#import "SnappingTabViewDelegate.h"

@interface SnappingTabViewController : UIViewController
@property (weak, nonatomic) id<SnappingTabViewDataSource> datasource;
@property (weak, nonatomic) id<SnappingTabViewDelegate> delegate;

@property (strong, nonatomic) UIFont* titleFont;
@property (nonatomic)         CGFloat indicatorHeight;
@property (strong, nonatomic) UIColor* indicatorColor;
@property (strong, nonatomic) UIColor* titleButtonHightlightColor;
@end
