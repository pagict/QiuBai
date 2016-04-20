//
//  QiuBaiImageRotateProcessor.m
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageRotateProcessor.h"

@implementation QiuBaiImageRotateProcessor
- (UIImage*)decorateImage:(UIImage *)image {
    UIImage* decorated = [super decorateImage:image];

    UIView* rotateBoxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, decorated.size.width, decorated.size.height)];
    CGAffineTransform trans = CGAffineTransformMakeRotation(self.rotateDegree);
    rotateBoxView.transform = trans;
    CGSize rotateSize = rotateBoxView.frame.size;
    UIGraphicsBeginImageContext(rotateSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotateSize.width / 2, rotateSize.height / 2);
    CGContextRotateCTM(bitmap, self.rotateDegree);
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(- decorated.size.width / 2, - decorated.size.height / 2, decorated.size.width, decorated.size.height), decorated.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
