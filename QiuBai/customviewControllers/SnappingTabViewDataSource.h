//
// Created by PengPremium on 16/3/30.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SnappingTabViewController;

@protocol SnappingTabViewDataSource <NSObject>
- (NSArray<UIView*> *)viewsInSnappingTabViewController:(SnappingTabViewController *)controller;
- (NSArray<NSString*> *)titlesInSnappingTabViewController:(SnappingTabViewController *)controller;
@end