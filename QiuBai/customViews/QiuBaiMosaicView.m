//
//  QiuBaiMosaicView.m
//  QiuBai
//
//  Created by PengPremium on 16/4/20.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiMosaicView.h"

@interface QiuBaiMosaicView ()
@property (strong, nonatomic)      IBOutlet    UIButton* cancelButton;
@property (strong, nonatomic)      IBOutlet    UIButton* resizeButton;
@property (strong, nonatomic)      IBOutlet    UIImageView* imageView;

@property (assign, nonatomic)       CGPoint     lastLocation;
@property (assign, nonatomic)       CGPoint     localLocation;
@end

@implementation QiuBaiMosaicView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat buttonWidth = 10;
        CGFloat buttonAlpha = 0.7;
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWidth, buttonWidth)];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel_x"] forState:UIControlStateNormal];
        self.cancelButton.layer.cornerRadius = buttonWidth / 2;
//        self.cancelButton.backgroundColor = [UIColor lightGrayColor];
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.alpha = buttonAlpha;
        [self.cancelButton addTarget:self action:@selector(cancelMosaic:) forControlEvents:UIControlEventTouchUpInside];

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(buttonWidth / 2, buttonWidth / 2,
                                                                      frame.size.width - buttonWidth,
                                                                       frame.size.height - buttonWidth)];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = self.mosaicImage;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        self.resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - buttonWidth,
                                                                      frame.size.height - buttonWidth,
                                                                       buttonWidth, buttonWidth)];
        [self.resizeButton setImage:[UIImage imageNamed:@"resize"] forState:UIControlStateNormal];
        self.resizeButton.layer.cornerRadius = buttonWidth / 2;
//        self.resizeButton.backgroundColor = [UIColor lightGrayColor];
        self.resizeButton.layer.masksToBounds = YES;
        self.resizeButton.alpha = buttonAlpha;
        [self.resizeButton addTarget:self action:@selector(resizeMosaic:) forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:self.imageView];
        [self addSubview:self.cancelButton];
        [self addSubview:self.resizeButton];
    }
    return self;
}

- (UIImage*)mosaicImage {
    if (!_mosaicImage) {
        _mosaicImage = [UIImage imageNamed:@"qiubai-logo"];
    }
    return _mosaicImage;
}


- (IBAction)cancelMosaic:(id)sender {

}

- (IBAction)resizeMosaic:(id)sender {

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* t = [touches anyObject];
    self.localLocation = [t locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* t = [touches anyObject];
    CGPoint estimateOrigin = [self nearestOriginInSuperviewForTouch:t];
    CGRect frame = self.frame;
    frame.origin = estimateOrigin;
    self.frame = frame;

    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* t = [touches anyObject];
    CGPoint estimateOrigin = [self nearestOriginInSuperviewForTouch:t];
    CGRect frame = self.frame;
    frame.origin = estimateOrigin;
    self.frame = frame;

    [self setNeedsDisplay];

}

- (CGPoint)nearestOriginInSuperviewForTouch:(UITouch*)touch {
    CGPoint superLocation = [touch locationInView:self.superview];
    CGRect expectedFrameInSuperview = CGRectZero;
    expectedFrameInSuperview.size = self.frame.size;
    expectedFrameInSuperview.origin.x = superLocation.x - self.localLocation.x;
    expectedFrameInSuperview.origin.y = superLocation.y - self.localLocation.y;
    CGRect superViewRect = CGRectMake(0, 0, self.superViewSize.width, self.superViewSize.height);
    if ( CGRectContainsRect(superViewRect, expectedFrameInSuperview)) {
        return expectedFrameInSuperview.origin;
    }

    if (expectedFrameInSuperview.origin.x < 0) {
        expectedFrameInSuperview.origin.x = 0;
    } else if (expectedFrameInSuperview.origin.x + self.frame.size.width > self.superViewSize.width) {
        expectedFrameInSuperview.origin.x = self.superViewSize.width - self.frame.size.width;
    }

    if (expectedFrameInSuperview.origin.y < 0) {
        expectedFrameInSuperview.origin.y = 0;
    } else if (expectedFrameInSuperview.origin.y + self.frame.size.height > self.superViewSize.height) {
        expectedFrameInSuperview.origin.y = self.superViewSize.height - self.frame.size.height;
    }

    return expectedFrameInSuperview.origin;
}
@end
