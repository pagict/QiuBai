//
//  SnappingTabView.m
//  QiuBai
//
//  Created by PengPremium on 16/3/30.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "SnappingTabView.h"

typedef enum {
    SnappingTabViewScrollDirectionForward,
    SnappingTabViewScrollDirectionBackward
} SnappingTabViewScrollDirection;

@interface SnappingTabView() <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIStackView *tabTitlesView;
@property (strong, nonatomic) IBOutlet UIView* indicatorView;
@property (strong, nonatomic) IBOutlet UIView* indicatorBar;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;
@property (strong, nonatomic) NSArray<UIView*>* containedViews;

@property (assign, nonatomic) CGFloat beginDraggingOffsetX;

@end

@implementation SnappingTabView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.titleViewHeight = 25;
        self.indicatorHeight = 3;
        self.currentPageIndex = 0;
        [self initViewsWithFrame:frame];
    }

    return self;
}

- (void)initViewsWithFrame:(CGRect)frame {
    CGRect titlesViewFrame = CGRectMake(0,
                                        0,
                                        frame.size.width,
                                        self.titleViewHeight);
    self.tabTitlesView = [[UIStackView alloc] initWithFrame:titlesViewFrame];
    self.tabTitlesView.axis = UILayoutConstraintAxisHorizontal;
    self.tabTitlesView.distribution = UIStackViewDistributionFillEqually;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;
    self.tabTitlesView.layoutMarginsRelativeArrangement = YES;
    self.tabTitlesView.autoresizesSubviews = YES;

    [self addSubview:self.tabTitlesView];

    CGRect indicatorsViewFrame = CGRectMake(titlesViewFrame.origin.x,
                                            titlesViewFrame.origin.y + titlesViewFrame.size.height,
                                            titlesViewFrame.size.width,
                                            self.indicatorHeight);
    self.indicatorView = [[UIView alloc] initWithFrame:indicatorsViewFrame];
    [self addSubview:self.indicatorView];
    self.indicatorBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                                 indicatorsViewFrame.size.width, indicatorsViewFrame.size.height)];
    self.indicatorBar.backgroundColor = self.indicatorColor;
    self.indicatorBar.layer.cornerRadius = self.indicatorBar.frame.size.height / 2;
    [self.indicatorView addSubview:self.indicatorBar];
    [self hightTitleAtIndex:0];

    CGRect scrollViewFrame = CGRectMake(frame.origin.x,
                                        0 + indicatorsViewFrame.origin.y + indicatorsViewFrame.size.height,
                                        frame.size.width,
                                        frame.size.height - titlesViewFrame.size.height - indicatorsViewFrame.size.height);

    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)hightTitleAtIndex:(NSInteger)index {
    if (self.tabTitlesView.arrangedSubviews.count <= index) {
        return;
    }
    CGRect titleButtonFrame = self.tabTitlesView.arrangedSubviews[index].frame;
    CGRect indicatorFrame = self.indicatorBar.frame;
    indicatorFrame.origin.x = titleButtonFrame.origin.x;
    indicatorFrame.size.width = titleButtonFrame.size.width;

    [UIView animateWithDuration:0.5
                     animations:^{
                         self.indicatorBar.frame = indicatorFrame;
                     }];
}

- (UIColor*)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor orangeColor];
    }
    return _indicatorColor;
}

- (UIFont*)titleFont {
    if (!_titleFont) {
        _titleFont = [UIFont systemFontOfSize:self.titleViewHeight];
    }
    return _titleFont;
}

- (void)setDatasource:(id<SnappingTabViewDataSource>)datasource {
    NSArray<NSString*>* titles = [datasource titlesInSnappingTabView:self];
    [self setupTitleBar:titles];

    self.containedViews =  [NSArray arrayWithArray:[datasource viewsInSnappingTabView:self]];
    [self setupScrollViewPages:self.containedViews];
    self.currentPageView = self.containedViews[self.currentPageIndex];
}

- (void)setupIndicatorView {
    CGRect titlesViewRect = self.tabTitlesView.frame;
    CGRect indicatorViewRect = CGRectMake(titlesViewRect.origin.x, titlesViewRect.origin.y + titlesViewRect.size.height,
                                          titlesViewRect.size.width, self.indicatorHeight);
    self.indicatorView.frame = indicatorViewRect;
    [self hightTitleAtIndex:self.currentPageIndex];
}


- (void)setupTitleBar:(NSArray<NSString*>*)titles {
    CGFloat btnWidth = 50;
    CGFloat width = btnWidth * titles.count + self.tabTitlesView.spacing * (titles.count - 1);
    CGFloat originX = self.frame.size.width / 2 - width / 2;
    CGRect  newFrame = CGRectMake(originX, 0, width, self.titleViewHeight);
    self.tabTitlesView.frame = newFrame;


    int i = 0;
    for (i = 0; i < titles.count; i++) {
        NSString* title = titles[i];

        CGRect btnFrame = CGRectMake(i * btnWidth, 0, btnWidth, self.titleViewHeight);
        UIButton* btn = [[UIButton alloc] initWithFrame:btnFrame];
        [btn addTarget:self
                action:@selector(scrollToPageWithTitleButton:)
      forControlEvents:UIControlEventTouchUpInside];

        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        btn.titleLabel.font = self.titleFont;
        btn.showsTouchWhenHighlighted = YES;

        [self.tabTitlesView addArrangedSubview:btn];
    }

    [self setupIndicatorView];
}

- (void)setupScrollViewPages:(NSArray<UIView*>*)tabViews {

    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * tabViews.count,
                                             self.scrollView.frame.size.height);

    int i = 0;
    for( UIView* tabView in tabViews) {
        CGRect frame = tabView.frame;
        frame.origin.x = i++ * self.scrollView.frame.size.width;
        tabView.frame = frame;
        [self.scrollView addSubview:tabView];
    }
}

- (CGRect)subPageRect {
    return self.scrollView.bounds;
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"%s", __func__);
//    self.beginDraggingOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"%s", __func__);
    NSUInteger newIndex = self.currentPageIndex;

    if (self.beginDraggingOffsetX > targetContentOffset->x) {
        newIndex = MAX(self.currentPageIndex - 1, 0);
    }
    if (self.beginDraggingOffsetX < targetContentOffset->x) {
        newIndex = MIN(self.currentPageIndex + 1, self.containedViews.count - 1);
    }

    self.currentPageIndex = newIndex;
    self.currentPageView = self.containedViews[self.currentPageIndex];

//    [self hightTitleAtIndex:self.currentPageIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"%s", __func__);

    self.currentPageView = self.containedViews[self.currentPageIndex];
    [self hightTitleAtIndex:self.currentPageIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {


    NSInteger nextPageIndex = self.currentPageIndex;

    // You can drag only ONE page a time.
    if (self.beginDraggingOffsetX > scrollView.contentOffset.x) {
        nextPageIndex = MAX(self.currentPageIndex - 1, 0);
    } else {
        nextPageIndex = MIN(self.currentPageIndex + 1, self.containedViews.count - 1);
    }

    UIButton* nextTabButton = (UIButton*)self.tabTitlesView.arrangedSubviews[nextPageIndex];
    UIButton* currentTabButton = (UIButton*)self.tabTitlesView.arrangedSubviews[self.currentPageIndex];
    CGFloat buttonsGrap = nextTabButton.frame.origin.x - currentTabButton.frame.origin.x;

    UIView* nextView = self.containedViews[nextPageIndex];
    if (nextView == self.currentPageView) {
        return;
    }
       NSLog(@"%s", __func__);
    CGFloat viewsGrap = nextView.frame.origin.x - self.currentPageView.frame.origin.x;

    CGFloat movingRatio = (scrollView.contentOffset.x - self.beginDraggingOffsetX) / viewsGrap * buttonsGrap;

    CGRect indicatorBarFrame = self.indicatorBar.frame;
    indicatorBarFrame.origin.x = movingRatio + currentTabButton.frame.origin.x;
    self.indicatorBar.frame = indicatorBarFrame;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(snappingTabView:didScrollToViewAtIndex:)]) {
        [self.delegate snappingTabView:self didScrollToViewAtIndex:self.currentPageIndex];
    }
    self.beginDraggingOffsetX = scrollView.contentOffset.x;
}

- (void)scrollToPageAtIndex:(NSInteger)pageIndex {
    [self hightTitleAtIndex:pageIndex];
    CGRect viewRect = CGRectZero;
    viewRect.size = self.scrollView.frame.size;
    viewRect.origin = CGPointZero;
    viewRect.origin.x = pageIndex * viewRect.size.width;
    [self.scrollView scrollRectToVisible:viewRect animated:YES];
}

- (IBAction)scrollToPageWithTitleButton:(id)sender {
    NSInteger index = 0;
    for (UIButton* btn in self.tabTitlesView.arrangedSubviews) {
        if (btn == sender) {
            break;
        }

        index++;
    }

    [self scrollToPageAtIndex:index];
}
@end
