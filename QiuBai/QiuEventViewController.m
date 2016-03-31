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


@interface QiuEventViewController ()<SnappingTabViewDataSource>

@end

@implementation QiuEventViewController

#pragma mark - SnappingTabViewDataSource
- (NSArray<UIView*> *)viewsInSnappingTabViewController:(SnappingTabViewController *)controller {
    UITableView *t1 = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    t1.backgroundColor = [UIColor greenColor];
    UITableView *t2 = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    t2.backgroundColor = [UIColor blueColor];
    return @[t1, t2];
    return nil; //TODO
}
- (NSArray<NSString*> *)titlesInSnappingTabViewController:(SnappingTabViewController *)controller {
    return @[@"tab1", @"tabl"];
    return nil; //TODO
}

- (instancetype)init {
    SnappingTabViewController *snappingTabViewController = [[SnappingTabViewController alloc] init];
    snappingTabViewController.datasource = self;
    self = [super initWithRootViewController:snappingTabViewController];
    if (self) {
        self.navigationBar.translucent = NO;
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


@end