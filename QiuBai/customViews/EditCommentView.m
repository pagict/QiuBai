//
//  EditCommentView.m
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "EditCommentView.h"

@interface EditCommentView ()<UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton* emojiButton;
@property (strong, nonatomic) IBOutlet UITextView* editingTextView;
@property (strong, nonatomic) IBOutlet UIButton* commentButton;
@property (strong, nonatomic) UIFont*   textViewFont;
@property (nonatomic)       CGFloat topMargin;
@end


CGFloat widgetHorizontalGap = 5.0;
CGFloat buttonHeight = 30;
CGFloat commentButtonWidth = 50;

@implementation EditCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.topMargin = (frame.size.height - buttonHeight) / 2;
        self.textViewFont = [UIFont systemFontOfSize:17];


        CGRect emojiFrame = CGRectMake(self.topMargin, self.topMargin, buttonHeight, buttonHeight);
        self.emojiButton = [[UIButton alloc] initWithFrame:emojiFrame];
        [self.emojiButton setImage:[UIImage imageNamed:@"smiley_color"]
                          forState:UIControlStateNormal];

        CGFloat originX = frame.size.width - widgetHorizontalGap - commentButtonWidth;
        CGRect commentButtonFrame = CGRectMake(originX, self.topMargin, commentButtonWidth, buttonHeight);
        self.commentButton = [[UIButton alloc] initWithFrame:commentButtonFrame];
        [self.commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [self.commentButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self.commentButton addTarget:self
                               action:@selector(sendComment:)
                     forControlEvents:UIControlEventTouchUpInside];


        originX = emojiFrame.origin.x + emojiFrame.size.width + widgetHorizontalGap;
        CGFloat sizeWidth = frame.size.width - originX - self.commentButton.frame.size.width - widgetHorizontalGap;
        CGRect editFrame = CGRectMake(originX, self.topMargin, sizeWidth, 30);
        self.editingTextView = [[UITextView alloc] initWithFrame:editFrame];
        self.editingTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.editingTextView.layer.cornerRadius = 5.0;
        self.editingTextView.font = self.textViewFont;
        self.editingTextView.delegate = self;


        [self addSubview:self.emojiButton];
        [self addSubview:self.editingTextView];
        [self addSubview:self.commentButton];
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

- (void)textViewDidChange:(UITextView *)textView {
    int numberOfLines = textView.contentSize.height / textView.font.lineHeight;
    if (numberOfLines <= 4) {
        CGRect newTextViewFrame = textView.frame;
        newTextViewFrame.size.height = textView.contentSize.height;
//        newTextViewFrame.origin.y = textView.frame.origin.y + textView.frame.size.height - newTextViewFrame.size.height;

        CGRect newViewFrame = self.frame;
        CGFloat bottomMargin = self.frame.size.height - textView.frame.origin.y - textView.frame.size.height;
        newViewFrame.size.height = textView.contentSize.height + self.topMargin + bottomMargin;
        newViewFrame.origin.y = self.frame.origin.y + self.frame.size.height - newViewFrame.size.height;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.frame = newViewFrame;
                             textView.frame = newTextViewFrame;
                             [textView scrollRangeToVisible:NSMakeRange(0, 4)];
                             [textView setNeedsDisplay];
                             [self setNeedsLayout];
                         }];
    }
}

- (void)beginEditComment {
    [self.editingTextView becomeFirstResponder];
}

- (IBAction)sendComment:(id)sender {
    if (self.delegate) {
        [self.delegate didFinishedCommentEditing:self.editingTextView];
    }
}
@end
