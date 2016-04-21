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
@property (assign, nonatomic)       CGFloat     maximumMosaicImageWidth;
@property (assign, nonatomic)       CGFloat     minimumMosaicImageWidth;
@property (assign, nonatomic)       CGFloat     buttonWidth;
@end

@implementation QiuBaiMosaicView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.buttonWidth = 20;
        CGFloat buttonAlpha = 0.7;
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.buttonWidth, self.buttonWidth)];
        [self.cancelButton setImage:[UIImage imageNamed:@"cancel_x"] forState:UIControlStateNormal];
        self.cancelButton.layer.cornerRadius = self.buttonWidth / 2;
        self.cancelButton.layer.masksToBounds = YES;
        self.cancelButton.alpha = buttonAlpha;
        [self.cancelButton addTarget:self action:@selector(cancelMosaic:) forControlEvents:UIControlEventTouchUpInside];

        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.buttonWidth / 2, self.buttonWidth / 2,
                                                                      frame.size.width - self.buttonWidth,
                                                                       frame.size.height - self.buttonWidth)];
        self.imageView.userInteractionEnabled = YES;
        self.imageView.image = self.mosaicImage;
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;

        self.resizeButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - self.buttonWidth,
                                                                      frame.size.height - self.buttonWidth,
                                                                       self.buttonWidth, self.buttonWidth)];
        [self.resizeButton setImage:[UIImage imageNamed:@"resize"] forState:UIControlStateNormal];
        self.resizeButton.layer.cornerRadius = self.buttonWidth / 2;
        self.resizeButton.layer.masksToBounds = YES;
        self.resizeButton.alpha = buttonAlpha;
        UIPanGestureRecognizer* gestureRecog = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(resizeMosaicWithGesture:)];
        [self.resizeButton addGestureRecognizer:gestureRecog];

        [self addSubview:self.imageView];
        [self addSubview:self.cancelButton];
        [self addSubview:self.resizeButton];

        self.maximumMosaicImageWidth = 100;
        self.minimumMosaicImageWidth = 30;
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

- (void)resizeMosaicWithGesture:(UIGestureRecognizer*)gesture {
    static CGPoint firstLocation;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        firstLocation = [gesture locationInView:self];
    } else {
        CGPoint location = [gesture locationInView:self];
        CGFloat deltaX = location.x - firstLocation.x;
        CGFloat deltaY = location.y - firstLocation.y;

        CGFloat newWidth = MAX(deltaX, deltaY) + self.imageView.frame.size.width;
        newWidth = MIN(newWidth, self.maximumMosaicImageWidth);
        newWidth = MAX(newWidth, self.minimumMosaicImageWidth);

        [self updateViewWithImageViewWidth:newWidth];
    }
}

- (void)updateViewWithImageViewWidth:(CGFloat)imageViewWidth {
    CGRect viewRect = CGRectZero;
    viewRect.origin = self.frame.origin;
    viewRect.size = CGSizeMake(imageViewWidth + self.buttonWidth, imageViewWidth + self.buttonWidth);
    self.frame = viewRect;

    CGRect imageViewRect = self.imageView.frame;
    imageViewRect.size = CGSizeMake(imageViewWidth, imageViewWidth);
    self.imageView.frame = imageViewRect;

    CGRect resizeButtonRect = self.resizeButton.frame;
    resizeButtonRect.origin.x = imageViewRect.origin.x + imageViewRect.size.width - self.buttonWidth / 2;
    resizeButtonRect.origin.y = imageViewRect.origin.y + imageViewRect.size.height - self.buttonWidth / 2;
    self.resizeButton.frame = resizeButtonRect;

    [self setNeedsDisplay];
}

- (CGRect)mosaicRect {
    CGRect rect = self.frame;
    rect.origin.x += self.imageView.frame.origin.x;
    rect.origin.y += self.imageView.frame.origin.y;
    rect.size = self.imageView.frame.size;
    return rect;
}
@end
