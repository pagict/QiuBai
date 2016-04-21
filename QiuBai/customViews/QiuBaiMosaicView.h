//
//  QiuBaiMosaicView.h
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuBaiMosaicView : UIView
@property (strong, nonatomic)   UIImage* mosaicImage;
@property (assign, nonatomic)   CGSize   superViewSize;
@property (assign, nonatomic, readonly)     CGRect imageRect;
@end
