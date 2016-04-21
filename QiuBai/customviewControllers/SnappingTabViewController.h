//
//  SnappingTabViewController.h
//  QiuBai
//
//  Created by PengPremium on 16/4/21.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "../customViews/SnappingTabView.h"

@interface SnappingTabViewController : UIViewController<SnappingTabViewDelegate, SnappingTabViewDataSource>
- (instancetype)initWithViewRect:(CGRect)frame;
@end
