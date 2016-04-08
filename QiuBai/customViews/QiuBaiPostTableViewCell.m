//
//  QiuBaiPostTableViewCell.m
//  QiuBai
//
//  Created by PengPremium on 16/3/31.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiPostTableViewCell.h"
#import "QiuBaiPost.h"

@implementation QiuBaiPostTableViewCell

- (IBAction)tapToViewUserInfo:(id)sender {
    
}
- (IBAction)tapToLikePost:(id)sender {
    static BOOL colored = false;
    if (!colored) {                 //TODO: base on the condition that if you've liked before
        [self.likeButton setImage:[UIImage imageNamed:@"smiley_color.png"] forState:UIControlStateNormal];
        colored = true;
    } else {
        [self.likeButton setImage:[UIImage imageNamed:@"smiley_gray.png"] forState:UIControlStateNormal];
        colored = false;
    }
}
- (IBAction)tapToDislikePost:(id)sender {
    static BOOL colored = false;
    if (!colored) {                 //TODO: base on the condition that if you've liked before
        [self.dislikeButtn setImage:[UIImage imageNamed:@"angry_color.png"] forState:UIControlStateNormal];
        colored = true;
    } else {
        [self.dislikeButtn setImage:[UIImage imageNamed:@"angry_gray.png"] forState:UIControlStateNormal];
        colored = false;
    }
}
- (IBAction)tapToCommentPost:(id)sender {
}
- (IBAction)tapToSharePost:(id)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //Font
    self.contentLabelFont = [UIFont systemFontOfSize:17];
    self.infoLabelFont = [UIFont systemFontOfSize:15];
    // content Label
    self.postContentLabel.numberOfLines = 0;
    self.postContentLabel.textAlignment = NSTextAlignmentJustified;
    self.postContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.postContentLabel.textColor = [UIColor darkTextColor];

    //Info Label
    self.postInfoLable.textColor = [UIColor lightGrayColor];

    // NickName button
    [self.nickNameButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

- (void)setContentLabelFont:(UIFont *)contentLabelFont {
    self.postContentLabel.font = contentLabelFont;
}

- (UIFont*)contentLabelFont {
    return self.postContentLabel.font;
}

- (void)setInfoLabelFont:(UIFont *)infoLabelFont {
    self.postInfoLable.font = infoLabelFont;
}

- (void)setUpWith:(QiuBaiPost *)post {
    QiuBaiUser *author = post.postAuthor;

    [self.nickNameButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.nickNameButton setTitle:author.nickName forState:UIControlStateNormal];

    self.postContentLabel.text = post.postContent;
    self.postInfoLable.text =
            [NSString stringWithFormat:@"好笑 %llu - 评论 %lu", post.likeCount, (unsigned long)post.comments.count];
}

- (CGFloat)contentLabelHeightWithPost:(QiuBaiPost*)post {

    CGFloat width = [self cellWidth];
     CGFloat MAX_CELL_HEIGHT = 9999;
    CGSize size = CGSizeMake(width, MAX_CELL_HEIGHT);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = self.postContentLabel.lineBreakMode;
    NSDictionary* attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          self.contentLabelFont, NSFontAttributeName,
                                          style, NSParagraphStyleAttributeName, nil];

    CGRect rect = [post.postContent boundingRectWithSize:size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributesDictionary
                                   context:nil];
    return rect.size.height + 8 + 8;
}

- (CGFloat)staticHeight {
    return 8    // top margin
    + 40        // profile image view height
    + 8         // gap to content label
    + 8         // gap from content label to info label
    + 21        // info label
    + 8         // gap
    + 25        // like button height
    + 8         // bottom margin
    ;
}

- (CGFloat)cellWidth {
    return self.contentView.frame.size.width
    - 8 // leading margin
    - 8  // tailing margin
    ;
}
@end

