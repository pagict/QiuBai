//
//  QiuEventViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright (c) 2016 pi-lot.org. All rights reserved.
//


#import "QiuEventViewController.h"
#import "customViews/SnappingTabView.h"
#import "customViews/QiuBaiPostTableView.h"
#import "customViews/QiuBaiPostTableViewCell.h"
#import "QiuBaiPostDetailViewController.h"
#import "QiuBaiNewPostViewController.h"
#import "ModelStore.h"
#import "QiuBaiPost.h"
#import "QiuBaiUser.h"


@interface QiuEventViewController ()<SnappingTabViewDataSource, SnappingTabViewDelegate, UITableViewDataSource, UITableViewDelegate>
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
    newVCFrame.size.height -= self.navigationBar.frame.size.height;
    newVCFrame.size.height -= [self.topLayoutGuide length];
//    newVCFrame.s
    QiuBaiPostDetailViewController* pdvc = [[QiuBaiPostDetailViewController alloc] initWithFrame:newVCFrame];
    pdvc.post = post;
    [self pushViewController:pdvc animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.viewControllers[0].hidesBottomBarWhenPushed = NO;
}


#pragma mark - SnappingTabViewDataSource
- (NSArray<UIView*> *)viewsInSnappingTabView:(SnappingTabView *)snappingTabView {
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
- (NSArray<NSString*> *)titlesInSnappingTabView:(SnappingTabView *)snappingTabView {
    return @[@"tab1", @"long--tab--name"];
}

#pragma mark - SnappingTabView Delegate
- (void)updateView:(UIView *)view {
    [(UITableView*)view reloadData];
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
    CGFloat statusBarHeieght = [self prefersStatusBarHidden] ?
                                0:
                                [UIApplication sharedApplication].statusBarFrame.size.height;

    CGRect rect = CGRectMake(0, naviHeight + statusBarHeieght,
                             [UIScreen mainScreen].bounds.size.width,
                             [UIScreen mainScreen].bounds.size.height - naviHeight - tabHeight - statusBarHeieght);
    SnappingTabView *snappingTabView= [[SnappingTabView alloc] initWithFrame:rect];
    UIViewController* snappingTabViewController = [[UIViewController alloc] init];
    snappingTabViewController.view = snappingTabView;
    self.viewControllers = @[snappingTabViewController];
    self.subViews = [[NSMutableArray alloc] init];
    snappingTabView.datasource = self;
    snappingTabView.delegate = self;


    UIBarButtonItem* leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                       target:self
                                                                                       action:@selector(invegestigate:)];

    UIBarButtonItem* rightBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                    target:self
                                                                                    action:@selector(toPostNew:)];
    self.topViewController.navigationItem.title = @"糗事百科";
    self.topViewController.navigationItem.leftBarButtonItem = leftBarButton;
    self.topViewController.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)invegestigate:(id)sender {

}
- (IBAction)toPostNew:(id)sender {

    CGRect newVCFrame = self.view.frame;
    newVCFrame.origin.y += self.navigationBar.frame.size.height;
    newVCFrame.origin.y += [UIApplication sharedApplication].statusBarFrame.size.height;
    newVCFrame.size.height -= newVCFrame.origin.y;
    
    QiuBaiNewPostViewController* newPostVC = [[QiuBaiNewPostViewController alloc] initWithViewFrame:newVCFrame];

    UINavigationController* nc = [[UINavigationController alloc] initWithRootViewController:newPostVC];
    [self presentViewController:nc
                       animated:YES
                     completion:^{

                     }];
}

- (NSArray*)specialOfferPosts {
    ModelStore* sharedStore = [ModelStore sharedStore];
    NSArray* posts = [sharedStore allPosts];
    return posts;
}

- (CGRect)tableViewFrameRect {
    SnappingTabView* snappingTab = (SnappingTabView*)self.topViewController.view;
    return [snappingTab subViewRect];
}

@end
