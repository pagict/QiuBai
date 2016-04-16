//
//  AnonymousSwitch.m
//  QiuBai
//
//  Created by PengPremium on 16/4/15.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "AnonymousSwitch.h"

@interface AnonymousSwitch ()
@property (strong, nonatomic) IBOutlet UILabel* anonymousLabel;
@property (strong, nonatomic) IBOutlet UILabel* namedLabel;
@property (strong, nonatomic) IBOutlet UIImageView* onImageView;

@property (strong, nonatomic) UIImage* anonymousImage;
@property (strong, nonatomic) UIImage* namedImage;
@end

@implementation AnonymousSwitch
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.anonymousImage = [UIImage imageNamed:@"anonymous"];
        self.namedImage = [UIImage imageNamed:@"smiley_color"];
        self.backgroundColor = [UIColor clearColor];
        self.onTintColor = self.backgroundColor;
        self.tintColor = self.backgroundColor;

        CGRect anonymousRect = self.frame;
        anonymousRect.size.width /= 2;
        self.anonymousLabel = [[UILabel alloc] initWithFrame: anonymousRect];
        self.anonymousLabel.text = @"匿名";
        self.anonymousLabel.font = [UIFont systemFontOfSize:8];
        self.anonymousLabel.backgroundColor = self.onTintColor;
        [self.anonymousLabel sizeToFit];
        self.anonymousLabel.layer.cornerRadius = self.anonymousLabel.frame.size.height / 2;
        self.anonymousLabel.layer.masksToBounds = YES;
        CGPoint center = self.anonymousLabel.center;
        center.y = self.center.y;
        self.anonymousLabel.center = center;
        self.anonymousLabel.userInteractionEnabled = NO;


        CGRect namedRect = anonymousRect;
        namedRect.origin.x += namedRect.size.width;
        self.namedLabel = [[UILabel alloc] initWithFrame:namedRect];
        self.namedLabel.font = [UIFont systemFontOfSize:8];
        self.namedLabel.text = @"署名";
        self.namedLabel.backgroundColor = self.tintColor;
        [self.namedLabel sizeToFit];
        self.namedLabel.layer.masksToBounds = YES;
        self.namedLabel.layer.cornerRadius = self.namedLabel.frame.size.height / 2;
        namedRect = self.namedLabel.frame;
        namedRect.origin.x = self.frame.size.width - namedRect.size.width;
        namedRect.origin.y = (self.frame.size.height - namedRect.size.height) / 2;
        self.namedLabel.frame = namedRect;
        self.namedLabel.userInteractionEnabled = NO;


        CGRect imageViewRect = CGRectMake(0, 0, self.frame.size.height / 2, self.frame.size.height / 2);
        self.onImageView = [[UIImageView alloc] initWithFrame:imageViewRect];
        self.onImageView.layer.cornerRadius = imageViewRect.size.height / 2;
        self.onImageView.layer.masksToBounds = YES;
        self.onImageView.userInteractionEnabled = NO;

        [self flipValue:self];

        [self addTarget:self
                 action:@selector(flipValue:)
       forControlEvents:UIControlEventValueChanged];

        [self addSubview:self.anonymousLabel];
        [self addSubview:self.namedLabel];
        [self addSubview:self.onImageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
}

- (IBAction)flipValue:(id)sender {
    if (! self.isOn) {
        self.anonymousLabel.hidden = YES;
        self.namedLabel.hidden = NO;
        CGPoint center = CGPointMake(self.frame.size.height / 2, self.frame.size.height / 2);
//        self.onImageView.frame = self.onLabel.frame;
        self.onImageView.center = center;
        self.onImageView.image = self.namedImage;
    } else {
        self.anonymousLabel.hidden = NO;
        self.namedLabel.hidden = YES;
//        self.onImageView.frame = self.offLabel.frame;
        CGPoint center = CGPointMake(self.frame.size.width - self.frame.size.height / 2, self.frame.size.height / 2);
        self.onImageView.center = center;
        self.onImageView.image = self.anonymousImage;
    }
}

- (void)setAnonymous:(BOOL)anonymous {
    self.on = !anonymous;
}

- (BOOL)isAnonymous {
    return !self.isOn;
}
@end
