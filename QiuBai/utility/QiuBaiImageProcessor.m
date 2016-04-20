//
//  QiuBaiImageProcessor.m
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageProcessor.h"

@implementation QiuBaiImageProcessor
- (instancetype)initWithImageProcessor:(QiuBaiImageProcessor *)processor {
    self = [super init];
    if (self) {
        self.processor = processor;
    }
    return self;
}

- (UIImage*)decorateImage:(UIImage *)image {
    return self.processor ? [self.processor decorateImage:image] : image;
}

@end
