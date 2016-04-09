//
//  QiuEventViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright (c) 2016 pi-lot.org. All rights reserved.
//


#import "QiuEventViewController.h"
#import "customviewControllers/SnappingTabViewController.h"
#import "customviewControllers/SnappingTabViewDataSource.h"
#import "customViews/QiuBaiPostTableView.h"
#import "customViews/QiuBaiPostTableViewCell.h"
#import "QiuBaiPostDetailViewController.h"
#import "ModelStore.h"
#import "QiuBaiPost.h"
#import "QiuBaiUser.h"


@interface QiuEventViewController ()<SnappingTabViewDataSource, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray* subViews;
@property (strong, nonatomic) NSArray*  specialOfferPosts;
@end

@implementation QiuEventViewController

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger subViewIndex = -1;
    for(subViewIndex = 0; subViewIndex < self.subViews.count; subViewIndex++) {
        if (self.subViews[subViewIndex] == tableView) {
            break;
        }
    }

    switch (subViewIndex) {
        case 0:     return self.specialOfferPosts.count;
        default:    return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QiuBaiPost *post = self.specialOfferPosts[indexPath.section];

    return [(QiuBaiPostTableView*)tableView tableViewCellWithPost:post];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    QiuBaiPost* post = self.specialOfferPosts[indexPath.section];
    CGFloat height = [(QiuBaiPostTableView*)tableView tableViewCellHeightWithPost:post];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.viewControllers[0].hidesBottomBarWhenPushed = YES;

    QiuBaiPost* post = self.specialOfferPosts[indexPath.section];
    CGRect newVCFrame = self.view.frame;
    newVCFrame.size.height -= [self.bottomLayoutGuide length];
    QiuBaiPostDetailViewController* pdvc = [[QiuBaiPostDetailViewController alloc] initWithFrame:newVCFrame];
    pdvc.post = post;
    [self pushViewController:pdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.viewControllers[0].hidesBottomBarWhenPushed = NO;
}


#pragma mark - SnappingTabViewDataSource
- (NSArray<UIView*> *)viewsInSnappingTabViewController:(SnappingTabViewController *)controller {
    CGRect rect = [self tableViewFrameRect];
    QiuBaiPostTableView *t1 = [[QiuBaiPostTableView alloc] initWithFrame:rect];
    t1.dataSource = self;
    t1.delegate = self;
    [self.subViews addObject:t1];
    QiuBaiPostTableView *t2 = [[QiuBaiPostTableView alloc] initWithFrame:rect];
    t2.dataSource = self;
    t2.delegate = self;
    [self.subViews addObject:t2];
    return @[t1, t2]; 
}
- (NSArray<NSString*> *)titlesInSnappingTabViewController:(SnappingTabViewController *)controller {
    return @[@"tab1", @"long--tab--name"];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationBar.translucent = NO;
        self.tabBarController.tabBar.translucent = NO;
        self.tabBarItem.title = @"糗事";

    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    CGFloat naviHeight = self.navigationBar.frame.size.height;
    CGFloat tabHeight = self.tabBarController.tabBar.frame.size.height;
    CGRect rect = CGRectMake(0, naviHeight,
                             [UIScreen mainScreen].bounds.size.width,
                             [UIScreen mainScreen].bounds.size.height - naviHeight - tabHeight);
    SnappingTabViewController *snappingTabViewController = [[SnappingTabViewController alloc] initWithFrame:rect];
    self.viewControllers = @[snappingTabViewController];
    snappingTabViewController.datasource = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)specialOfferPosts {
    ModelStore* sharedStore = [ModelStore sharedStore];
    NSArray* posts = [sharedStore allPosts];
    return posts;
}

- (CGRect)tableViewFrameRect {
    SnappingTabViewController* snappingTab = (SnappingTabViewController*)self.topViewController;
    return [snappingTab subViewRect];
}

@end