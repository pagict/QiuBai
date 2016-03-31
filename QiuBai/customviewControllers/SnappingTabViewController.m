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

@end

@implementation SnappingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Default properties
    self.titleFont = [UIFont systemFontOfSize:10];
    // Do any additional setup after loading the view from its nib.
    CGFloat startY = self.topLayoutGuide.length;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

    NSArray<NSString*>* titles = [self.datasource titlesInSnappingTabViewController:self];

    CGFloat maxButtonWidth = 0;
    CGFloat maxButtonHeight = 0;
    NSMutableArray<UIButton*>* titleButtons = [[NSMutableArray alloc] init];
    for (NSString* title in titles) {
        UIButton* btn = [[UIButton alloc] init];
        [titleButtons addObject:btn];
        btn.titleLabel.text = title;
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
    CGRect tabsViewFrame = CGRectMake( screenWidth/2 - titleBarWidth/2, startY, titleBarWidth, maxButtonHeight);
    self.tabTitlesView = [[UIStackView alloc] initWithFrame:tabsViewFrame];
    self.tabTitlesView.axis = UILayoutConstraintAxisHorizontal;
    self.tabTitlesView.distribution = UIStackViewDistributionEqualCentering | UIStackViewDistributionFill;
    self.tabTitlesView.alignment = UIStackViewAlignmentCenter;
    self.tabTitlesView.layoutMarginsRelativeArrangement = YES;
    [self.tabTitlesView sizeToFit];


    [self.view addSubview:self.tabTitlesView];

    for (UIButton* btn in titleButtons) {
        [self.tabTitlesView addArrangedSubview:btn];

        CGRect frame = btn.frame;
        frame.size.width = maxButtonWidth;
        frame.size.height = maxButtonHeight;
        btn.frame = frame;
        btn.backgroundColor = [UIColor lightGrayColor];
    }
    NSArray<UIView*>* tabViews = [self.datasource viewsInSnappingTabViewController:self];

    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, screenHeight - 20)];
    [self.view addSubview:scrollView];

    scrollView.contentSize  = CGSizeMake(tabViews.count * screenWidth, screenHeight);
    scrollView.bounces = NO;

    int i = 0;
    for( UIView* tabView in tabViews) {
        CGRect frame = tabView.frame;
        frame.origin.x = i++ * screenWidth;
        tabView.frame = frame;
        [scrollView addSubview:tabView];
    }

    scrollView.pagingEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
