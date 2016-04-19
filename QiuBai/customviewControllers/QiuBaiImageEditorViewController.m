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

        UIImageView* iv = [[UIImageView alloc] initWithImage:_originImage];
        CGRect cancelRect = CGRectMake(20, 20, 60, 30);
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:cancelRect];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelSelectedImage:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:iv];
        [self.view addSubview:cancelButton];
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
@end
