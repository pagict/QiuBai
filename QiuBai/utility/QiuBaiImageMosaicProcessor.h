//
//  QiuBaiImageMosaicProcessor.h
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageProcessor.h"

@interface QiuBaiImageMosaicProcessor : QiuBaiImageProcessor
@property (nonatomic)   CGRect mosaicRect;
@property (strong, nonatomic)   UIImage* mosaicImage;
@end
