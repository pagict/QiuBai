//
//  QiuBaiImageWatermarkProcessor.m
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageWatermarkProcessor.h"

@implementation QiuBaiImageWatermarkProcessor
- (UIImage*)decorateImage:(UIImage *)image {
    UIImage* decoratedImage = [super decorateImage:image];
    if (!self.watermarkImage) {
        return decoratedImage;
    }
    CGImageRef maskRef = self.watermarkImage.CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef)
                                        , CGImageGetHeight(maskRef)
                                        , CGImageGetBitsPerComponent(maskRef)
                                        , CGImageGetBitsPerPixel(maskRef)
                                        , CGImageGetBytesPerRow(maskRef)
                                        , CGImageGetDataProvider(maskRef)
                                        , NULL, true);
    CGImageRef masked = CGImageCreateWithMask(decoratedImage.CGImage, mask);
    return [UIImage imageWithCGImage:masked];
}
@end
