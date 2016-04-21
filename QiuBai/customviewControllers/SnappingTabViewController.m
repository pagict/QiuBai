//
//  SnappingTabViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/3/30.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "SnappingTabViewController.h"

@interface SnappingTabViewController ()
@property (strong, nonatomic) IBOutlet UIStackView *tabTitlesView;
@property (strong, nonatomic) IBOutlet UIView* indicatorView;
@property (strong, nonatomic) IBOutlet UIScrollView* scrollView;

@property (strong, nonatomic) NSArray<UIView*>* subViews;
@end

@implementation SnappingTabViewController

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        CGRect rect = frame;
        rect.origin = CGPointZero;
        self.view = [[UIView alloc] initWithFrame:rect];
        self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.titleViewHeight = 20;
        self.indicatorHeight = 0;
        self.titleFont = [UIFont systemFontOfSize:self.titleViewHeight];

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
    self.tabTitlesView.distribution = UIStackViewDistributionEqualSpacing;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;
    self.tabTitlesView.layoutMarginsRelativeArrangement = YES;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;
    self.tabTitlesView.spacing = 2.0;
    self.tabTitlesView.autoresizesSubviews = YES;

    [self.view addSubview:self.tabTitlesView];

    CGRect indicatorsViewFrame = CGRectMake(titlesViewFrame.origin.x,
                                            titlesViewFrame.origin.y + titlesViewFrame.size.height,
                                            titlesViewFrame.size.width,
                                            self.indicatorHeight);
//    self.indicatorView = [[UIView alloc] initWithFrame:indicatorsViewFrame];                 //TODO
//    [self.view addSubview:self.indicatorView];

    CGRect scrollViewFrame = CGRectMake(frame.origin.x,
                                        0 + indicatorsViewFrame.origin.y + indicatorsViewFrame.size.height,
                                        frame.size.width,
                                        frame.size.height - titlesViewFrame.size.height - indicatorsViewFrame.size.height);

    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];
    self.scrollView.bounces = NO;
    self.scrollView.pagingEnabled = YES;
    [self.view addSubview:self.scrollView];

}

- (void)setDatasource:(id<SnappingTabViewDataSource>)datasource {
    NSArray<NSString*>* titles = [datasource titlesInSnappingTabViewController:self];
    [self setupTitleBar:titles];

    self.subViews =  [NSArray arrayWithArray:[datasource viewsInSnappingTabViewController:self]];
    [self setupScrollViewBy:self.subViews];
}

- (void)setupTitleBar:(NSArray<NSString*>*)titles {
    CGFloat btnWidth = 50;
    CGFloat width = btnWidth * titles.count + self.tabTitlesView.spacing * (titles.count - 1);
    CGFloat originX = self.view.frame.size.width / 2 - width / 2;
    CGRect  newFrame = CGRectMake(originX, 0, width, self.titleViewHeight);
    self.tabTitlesView.frame = newFrame;
    for (NSString* title in titles) {
        CGRect btnFrame = CGRectMake(0, 0, btnWidth, self.titleViewHeight);
        UIButton* btn = [[UIButton alloc] initWithFrame:btnFrame];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor lightGrayColor];
        [self.tabTitlesView addArrangedSubview:btn];
        btn.titleLabel.font = self.titleFont;
    }
}

- (void)setupScrollViewBy:(NSArray<UIView*>*)tabViews {

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

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (self.delegate) {
        for (UIView* view in self.subViews) {
            [self.delegate updateView:view];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)subViewRect {
    return self.scrollView.bounds;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
