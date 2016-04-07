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
    NSInteger subViewIndex = -1;
    for(subViewIndex = 0; subViewIndex < self.subViews.count; subViewIndex++) {
        if (self.subViews[subViewIndex] == tableView) {
            break;
        }
    }

    if (subViewIndex == 0) {
        return 1;
    }
    return 1;
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


#pragma mark - SnappingTabViewDataSource
- (NSArray<UIView*> *)viewsInSnappingTabViewController:(SnappingTabViewController *)controller {
    QiuBaiPostTableView *t1 = [[QiuBaiPostTableView alloc] init];
    t1.dataSource = self;
    t1.delegate = self;
    [self.subViews addObject:t1];
    QiuBaiPostTableView *t2 = [[QiuBaiPostTableView alloc] init];
    t2.dataSource = self;
    t2.delegate = self;
    [self.subViews addObject:t2];
    return @[t1, t2]; 
}
- (NSArray<NSString*> *)titlesInSnappingTabViewController:(SnappingTabViewController *)controller {
    return @[@"tab1", @"tabl"];
}

- (instancetype)init {
    SnappingTabViewController *snappingTabViewController = [[SnappingTabViewController alloc] init];
    snappingTabViewController.datasource = self;
    self = [super initWithRootViewController:snappingTabViewController];
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

@end