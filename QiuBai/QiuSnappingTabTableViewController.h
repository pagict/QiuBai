//
//  QiuSnappingTabTableViewController.h
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright (c) 2016 pi-lot.org. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "customViews/SnappingTabView.h"
/**
 *  A UIViewController integrated with SnappingTabView and UITableView.
 */
@interface QiuSnappingTabTableViewController : UIViewController
    <SnappingTabViewDataSource, SnappingTabViewDelegate,UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) SnappingTabView* snappingTabView;

@end
