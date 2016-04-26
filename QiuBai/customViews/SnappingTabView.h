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
@optional
- (void)snappingTabView:(SnappingTabView*)snappingTabView didScrollToViewAtIndex:(NSInteger)subPageIndex;
@end

@interface SnappingTabView: UIView
- (instancetype)initWithFrame:(CGRect)frame;

@property (weak, nonatomic) id<SnappingTabViewDataSource> datasource;
@property (weak, nonatomic) id<SnappingTabViewDelegate> delegate;

@property (nonatomic)         CGFloat indicatorHeight;
@property (nonatomic)         CGFloat titleViewHeight;

@property (strong, nonatomic) UIColor* indicatorColor;
@property (strong, nonatomic) UIFont* titleFont;
@property (strong, nonatomic) UIColor* titleTintColor;

@property (assign, nonatomic, readonly) NSInteger currentPageIndex;
@property (strong, nonatomic, readonly) UIView*   currentPageView;

@property (nonatomic, readonly) CGRect  subPageRect;

- (void)scrollToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)isAnimated;
@end
