//
//  QiuBaiPostTableView.m
//  QiuBai
//
//  Created by PengPremium on 16/3/31.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiPostTableView.h"
#import "QiuBaiPostTableViewCell.h"

@interface QiuBaiPostTableView () <UITableViewDelegate>

@end

@implementation QiuBaiPostTableView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame style:UITableViewStyleGrouped];
    if (self) {
        UINib* cellNib = [UINib nibWithNibName:@"QiuBaiPostTableViewCell" bundle:nil];
        [self registerNib:cellNib forCellReuseIdentifier:@"QiuBaiPostTableViewCell"];
        self.delegate = self;
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

- (CGFloat)sectionHeaderHeight {
    return 1.0;
}
@end
