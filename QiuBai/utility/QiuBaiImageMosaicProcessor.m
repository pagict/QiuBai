//
//  QiuBaiImageMosaicProcessor.m
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageMosaicProcessor.h"

@implementation QiuBaiImageMosaicProcessor
- (UIImage*)decorateImage:(UIImage *)image {
    UIImage* decorated = [super decorateImage:image];
    if (CGRectEqualToRect(self.mosaicRect, CGRectZero) || !self.mosaicImage) {
        return decorated;
    }

    UIGraphicsBeginImageContext(decorated.size);
    [decorated drawInRect:CGRectMake(0, 0, decorated.size.width, decorated.size.height)];
    [self.mosaicImage drawInRect:self.mosaicRect];
    UIImage* mergedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mergedImage;
}
@end
