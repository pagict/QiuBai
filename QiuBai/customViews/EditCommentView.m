//
//  EditCommentView.m
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "EditCommentView.h"

@interface EditCommentView ()
@property (strong, nonatomic) IBOutlet UIButton* emojiButton;
@property (strong, nonatomic) IBOutlet UITextView* editingTextView;
@property (strong, nonatomic) IBOutlet UIButton* commentButton;
@end

@implementation EditCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
