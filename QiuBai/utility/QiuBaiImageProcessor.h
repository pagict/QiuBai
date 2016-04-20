//
//  QiuBaiImageProcessor.h
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "QiuBaiImageRotateProcessor.h"
//#import "QiuBaiImageMosaicProcessor.h"
//#import "QiuBaiImageWatermarkProcessor.h"

@interface QiuBaiImageProcessor : NSObject
- (instancetype)initWithImageProcessor:(QiuBaiImageProcessor*)processor;
- (UIImage*)decorateImage:(UIImage*)image;

@property (strong, nonatomic) QiuBaiImageProcessor* processor;
@end
