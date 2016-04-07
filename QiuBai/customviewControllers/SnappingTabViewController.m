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
@end

@implementation SnappingTabViewController

- (instancetype)initWithFrame:(CGRect)frame {
//    self = [super initWithNibName:@"SnappingTabViewController" bundle:nil];
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.titleViewHeight = 20;
        self.indicatorHeight = 0;
        self.titleFont = [UIFont systemFontOfSize:self.titleViewHeight - 10];

        [self initViewsWithFrame:frame];
    }

    return self;
}

- (void)initViewsWithFrame:(CGRect)frame {
    CGRect titlesViewFrame = CGRectMake(frame.origin.x,
                                        0,
                                        frame.size.width,
                                        self.titleViewHeight);
    self.tabTitlesView = [[UIStackView alloc] initWithFrame:titlesViewFrame];
    self.tabTitlesView.axis = UILayoutConstraintAxisHorizontal;
    self.tabTitlesView.distribution = UIStackViewDistributionEqualCentering | UIStackViewDistributionFill;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;
    self.tabTitlesView.layoutMarginsRelativeArrangement = YES;
    self.tabTitlesView.distribution = UIStackViewDistributionEqualCentering | UIStackViewDistributionFill;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;

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

    NSArray<UIView*>* tabViews = [datasource viewsInSnappingTabViewController:self];
    [self setupScrollViewBy:tabViews];
}

- (void)setupTitleBar:(NSArray<NSString*>*)titles {
    CGFloat maxButtonWidth = 0;
    CGFloat maxButtonHeight = 0;
    NSMutableArray<UIButton*>* titleButtons = [[NSMutableArray alloc] init];
    for (NSString* title in titles) {
        UIButton* btn = [[UIButton alloc] init];
        [titleButtons addObject:btn];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = self.titleFont;
        [btn sizeToFit];
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        if (width > maxButtonWidth) {
            maxButtonWidth = width;
        }

        if (height > maxButtonHeight) {
            maxButtonHeight = height;
        }
    }

    CGFloat titleBarWidth = maxButtonWidth * titleButtons.count;
    CGRect tabsViewFrame = CGRectMake(self.scrollView.frame.origin.x + self.scrollView.frame.size.width/2 - titleBarWidth/2,
                                      self.tabTitlesView.frame.origin.y,
                                      titleBarWidth,
                                      maxButtonHeight);
    self.tabTitlesView.frame = tabsViewFrame;

    for (UIButton* btn in titleButtons) {
        [self.tabTitlesView addArrangedSubview:btn];

        CGRect frame = btn.frame;
        frame.size.width = maxButtonWidth;
        frame.size.height = maxButtonHeight;
        btn.frame = frame;
        btn.backgroundColor = [UIColor lightGrayColor];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGRect)subViewRect {
    return self.scrollView.frame;
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
