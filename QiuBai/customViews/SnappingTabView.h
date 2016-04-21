//
//  SnappingTabView.h
//  QiuBai
//
//  Created by PengPremium on 16/3/30.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SnappingTabView;

@protocol SnappingTabViewDataSource <NSObject>
- (NSArray<UIView*> *)viewsInSnappingTabView:(SnappingTabView*)snappingTabView;
- (NSArray<NSString*> *)titlesInSnappingTabView:(SnappingTabView*)snappingTabView;
@end

@protocol SnappingTabViewDelegate <NSObject>

@required
- (void)updateView:(UIView*)view;
@optional
- (void)snappingTabView:(SnappingTabView*)snappingTabView didScrollToViewAtIndex:(NSInteger)subPageIndex;
@end

@interface SnappingTabView: UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id<SnappingTabViewDataSource> datasource;
@property (weak, nonatomic) id<SnappingTabViewDelegate> delegate;

@property (strong, nonatomic) UIFont* titleFont;
@property (nonatomic)         CGFloat indicatorHeight;
@property (strong, nonatomic) UIColor* indicatorColor;
@property (strong, nonatomic) UIColor* titleButtonHightlightColor;

@property (nonatomic)         CGFloat titleViewHeight;

@property (nonatomic, readonly) CGRect  subViewRect;
@end
