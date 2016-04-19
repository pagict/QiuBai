//
//  ImageProcessor.h
//  QiuBai
//
//  Created by PengPremium on 16/4/19.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSInteger {
    QiuBaiImageProcessorRotateOrientationClockwise = 0,
    QiuBaiImageProcessorRotateOrientationCounterClockwise
} QiuBaiImageProcessorRotateOrientation;

@interface ImageProcessor : NSObject
+ (UIImage*)watermarkedImageForImage:(UIImage*)originImage;
+ (UIImage*)rotatedImageForImage:(UIImage*)originImage
           withRotateOrientation:(QiuBaiImageProcessorRotateOrientation)orientation;
+ (UIImage*)mosaicedImageForImage:(UIImage*)originImage mosaicRect:(CGRect)mosaicRect;
@end
