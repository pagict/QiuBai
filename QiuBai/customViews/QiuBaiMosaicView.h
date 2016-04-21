//
//  QiuBaiMosaicView.h
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QiuBaiMosaicView;

@protocol QiuBaiMosaicViewDelegate <NSObject>

- (void)cancelledMosaicView:(QiuBaiMosaicView*)mosaicView;

@end

@interface QiuBaiMosaicView : UIView
@property (strong, nonatomic)   UIImage* mosaicImage;
@property (assign, nonatomic)   CGSize   superViewSize;
@property (weak, nonatomic)     id<QiuBaiMosaicViewDelegate> delegate;
@property (assign, nonatomic, readonly)     CGRect imageRect;
@end
