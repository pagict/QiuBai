//
//  SnappingTabViewDelegate.h
//  QiuBai
//
//  Created by PengPremium on 16/3/30.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//
#import <Foundation/Foundation.h>

@class SnappingTabViewController;

@protocol SnappingTabViewDelegate <NSObject>

@required

@optional
- (void)snappingTabViewController:(SnappingTabViewController*)scroll didScrollToViewAtIndex:(NSInteger)subPageIndex;
@end
