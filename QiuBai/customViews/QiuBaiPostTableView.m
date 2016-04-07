//
//  QiuBaiPostTableView.m
//  QiuBai
//
//  Created by PengPremium on 16/3/31.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiPostTableView.h"
#import "QiuBaiPostTableViewCell.h"

@implementation QiuBaiPostTableView
- (instancetype)init {
    self = [super initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    if (self) {
        UINib* cellNib = [UINib nibWithNibName:@"QiuBaiPostTableViewCell" bundle:nil];
        [self registerNib:cellNib forCellReuseIdentifier:@"QiuBaiPostTableViewCell"];
    }
    return self;
}

- (QiuBaiPostTableViewCell*)tableViewCellWithPost:(QiuBaiPost*)post {
    QiuBaiPostTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
  
    [cell setUpWith:post];
    return cell;
}

- (CGFloat)tableViewCellHeightWithPost:(QiuBaiPost *)post {
    QiuBaiPostTableViewCell* cell = [self dequeueReusableCellWithIdentifier:@"QiuBaiPostTableViewCell"];
    return [cell heightWithPost:post] + [cell staticHeight];
}

@end
