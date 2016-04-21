//
//  SnappingTabViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/21.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "SnappingTabViewController.h"
#import "../customViews/SnappingTabView.h"

@implementation SnappingTabViewController
- (instancetype)initWithViewRect:(CGRect)frame {
    self = [super init];
    if (self) {
        self.view = [[SnappingTabView alloc] initWithFrame:frame];
    }
    return self;
}

//- (void)
@end
