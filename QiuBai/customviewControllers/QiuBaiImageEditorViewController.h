//
//  QiuBaiImageEditorViewController.h
//  QiuBai
//
//  Created by PengPremium on 16/4/19.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiuBaiImageEditorViewController : UIViewController
- (instancetype)initWithImage:(UIImage*)image;

@property (copy, readonly, nonatomic)   UIImage* originImage;
@property (strong, nonatomic)           UIImage* currentImage;
@end
