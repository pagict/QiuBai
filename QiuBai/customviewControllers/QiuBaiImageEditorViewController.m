//
//  QiuBaiImageEditorViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/19.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageEditorViewController.h"
#import "QiuBaiImageSelectionController.h"

@interface QiuBaiImageEditorViewController ()
@property (strong, nonatomic)   NSMutableArray* mosaicViews;
@end

@implementation QiuBaiImageEditorViewController
- (instancetype)initWithImage:(UIImage *)image {
    self = [super init];
    if (self) {
        _originImage = [image copy];
        self.currentImage = _originImage;
        self.mosaicViews = [[NSMutableArray alloc] init];

        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;

        CGRect cancelRect = CGRectMake(0, 0, 100, 44);
        cancelRect.origin.x = screenWidth / 4 - cancelRect.size.width / 2;
        UIButton* cancelButton = [[UIButton alloc] initWithFrame:cancelRect];
        cancelButton.backgroundColor = self.view.backgroundColor;
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectedImage:) forControlEvents:UIControlEventTouchUpInside];

        CGRect confirmRect = cancelRect;
        confirmRect.origin.x += screenWidth / 2;
        UIButton* confirmButton = [[UIButton alloc] initWithFrame:confirmRect];
        confirmButton.backgroundColor = self.view.backgroundColor;
        [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [confirmButton addTarget:self action:@selector(confirmImage:) forControlEvents:UIControlEventTouchUpInside];

        CGRect rotateRect = cancelRect;
        rotateRect.origin.y = screenHeight - rotateRect.size.height;
        UIButton* rotateButton = [[UIButton alloc] initWithFrame:rotateRect];
        rotateButton.backgroundColor = self.view.backgroundColor;
        rotateButton.contentMode = UIViewContentModeScaleAspectFit;
        rotateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [rotateButton setTitle:@"旋转" forState:UIControlStateNormal];
        [rotateButton setImage:[UIImage imageNamed:@"rotate_icon"] forState:UIControlStateNormal];
        [rotateButton addTarget:self action:@selector(rotateImage:) forControlEvents:UIControlEventTouchUpInside];

        CGRect mosaicRect = confirmRect;
        mosaicRect.origin.y = rotateRect.origin.y;
        UIButton* mosaicButton = [[UIButton alloc] initWithFrame:mosaicRect];
        mosaicButton.backgroundColor = self.view.backgroundColor;
        mosaicButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        mosaicButton.contentMode = UIViewContentModeScaleAspectFit;
        [mosaicButton setImage:[UIImage imageNamed:@"mosaic"] forState:UIControlStateNormal];
        [mosaicButton setTitle:@"打码" forState:UIControlStateNormal];
        [mosaicButton addTarget:self action:@selector(addMosaic:) forControlEvents:UIControlEventTouchUpInside];

        CGRect imageViewRect = CGRectMake(0, cancelRect.origin.y + cancelRect.size.height,
                                          screenWidth, mosaicRect.origin.y - cancelRect.origin.y - cancelRect.size.height);
        UIImageView* iv = [[UIImageView alloc] initWithFrame:imageViewRect];
        iv.image = image;
        iv.contentMode = UIViewContentModeScaleAspectFit;
        iv.backgroundColor = [UIColor grayColor];

        [self.view addSubview:iv];
        [self.view addSubview:cancelButton];
        [self.view addSubview:confirmButton];
        [self.view addSubview:rotateButton];
        [self.view addSubview:mosaicButton];
    }
    return self;
}

- (IBAction)cancelSelectedImage:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{

    }];
}

- (IBAction)confirmImage:(id)sender {

}

- (IBAction)rotateImage:(id)sender {

}

- (IBAction)addMosaic:(id)sender {

}

- (BOOL)prefersStatusBarHidden   {
    return YES;
}
@end
