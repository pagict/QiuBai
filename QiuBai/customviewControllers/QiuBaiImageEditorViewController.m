//
//  QiuBaiImageEditorViewController.m
//  QiuBai
//
//  Created by PengPremium on 16/4/19.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiImageEditorViewController.h"
#import "QiuBaiImageSelectionController.h"
#import "../utility/QiuBaiImageProcessors.h"
#import "../customViews/QiuBaiMosaicView.h"

@interface QiuBaiImageEditorViewController () <QiuBaiMosaicViewDelegate>
@property (strong, nonatomic)   UIView* imageBackgroundView;
@property (strong, nonatomic)   UIImageView* imageView;
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

        CGRect imageBgViewRect = CGRectMake(0, cancelRect.origin.y + cancelRect.size.height,
                                          screenWidth, mosaicRect.origin.y - cancelRect.origin.y - cancelRect.size.height);
        self.imageBackgroundView = [[UIView alloc] initWithFrame:imageBgViewRect];
        self.imageBackgroundView.backgroundColor = [UIColor grayColor];

        CGRect imageViewRect = imageBgViewRect;
        imageViewRect.origin = CGPointZero;
        self.imageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        [self.imageBackgroundView addSubview:self.imageView];
//        self.imageView.backgroundColor = [UIColor grayColor];

        [self.view addSubview:self.imageBackgroundView];
        [self.view addSubview:cancelButton];
        [self.view addSubview:confirmButton];
        [self.view addSubview:rotateButton];
        [self.view addSubview:mosaicButton];


        [self setImage:image];
    }
    return self;
}

- (IBAction)cancelSelectedImage:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{

    }];
}

- (IBAction)confirmImage:(id)sender {

}

- (void)setImage:(UIImage*)image {
    self.imageView.image = image;
    CGFloat imageScaleFactor = MIN(self.imageBackgroundView.bounds.size.width / image.size.width,
                                   self.imageBackgroundView.bounds.size.height / image.size.height);
    CGRect newFrame = CGRectMake(0, 0, image.size.width * imageScaleFactor, image.size.height * imageScaleFactor);
    self.imageView.frame = newFrame;
    self.imageView.center = CGPointMake(self.imageBackgroundView.frame.size.width / 2,
                                        self.imageBackgroundView.frame.size.height / 2);
    [self.imageBackgroundView setNeedsDisplay];
}

- (IBAction)rotateImage:(id)sender {
    UIImage* currentImage = self.imageView.image;
    QiuBaiImageRotateProcessor* ip = [[QiuBaiImageRotateProcessor alloc] init];
    ip.rotateDegree = M_PI_2;
    UIImage* newImage = [ip decorateImage:currentImage];
    [self setImage:newImage];

    for (QiuBaiMosaicView* view in self.mosaicViews) {
        view.superViewSize = self.imageView.frame.size;
        if ( ! CGRectContainsRect(self.imageView.bounds, view.frame)) {
            CGRect rect = view.frame;
            rect.origin = CGPointZero;
            view.frame = rect;
        }
    }
}

- (IBAction)addMosaic:(id)sender {
    CGRect mosaicRect = CGRectZero;
    mosaicRect.origin = self.imageView.center;
    mosaicRect.size = CGSizeMake(50, 50);
    QiuBaiMosaicView *mosaicView = [[QiuBaiMosaicView alloc] initWithFrame:mosaicRect];
    mosaicView.superViewSize = self.imageView.bounds.size;
    mosaicView.delegate = self;
    [self.imageView addSubview:mosaicView];
    [self.mosaicViews addObject:mosaicView];
}

- (BOOL)prefersStatusBarHidden   {
    return YES;
}

- (void)viewWillAppear:(BOOL)animated {
//    UIImage* currentImage = self.imageView.image;
//    QiuBaiImageWatermarkProcessor* ip =  [[QiuBaiImageWatermarkProcessor alloc] init];
//    ip.watermarkImage = [UIImage imageNamed:@"qiubai-logo"];
//    UIImage* newImage = [ip decorateImage:currentImage];
//    self.imageView.image = newImage;
}

#pragma mark - QiuBaiMosaicView Delegate
- (void)cancelledMosaicView:(QiuBaiMosaicView *)mosaicView {
    [self.mosaicViews removeObject:mosaicView];
}
@end
