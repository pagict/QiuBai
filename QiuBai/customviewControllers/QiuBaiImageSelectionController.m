//
//  QiuBaiImageSelectionController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/19.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageSelectionController.h"
#import "QiuBaiImageEditorViewController.h"
//@class QiuBaiImageEditorViewController;

@implementation QiuBaiImageSelectionController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([self.presentedViewController isKindOfClass:[QiuBaiImageEditorViewController class]]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
