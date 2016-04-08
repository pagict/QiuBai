//
//  QiuBaiCommentTableViewCell.m
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "QiuBaiCommentTableViewCell.h"
#import "../models/QiuBaiUser.h"

@interface QiuBaiCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *nickNameButton;
@property (weak, nonatomic) IBOutlet UIButton *floatMenuButton;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@end

@implementation QiuBaiCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nickNameButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.nickNameButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.floatMenuButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.commentContentLabel.font = self.contentLabelFont;
    self.commentContentLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setupWith:(QiuBaiComment *)comment {
    QiuBaiUser* author = comment.commentAuthor;

    [self.nickNameButton setTitle:author.nickName forState:UIControlStateNormal];
    [self.floatMenuButton setTitle:[NSString stringWithFormat:@"%lu", comment.respondComments.count] forState:UIControlStateNormal];
    self.commentContentLabel.text = comment.commentContent;
    self.commentTimeLabel.text = @"TODO: comment Time";
    [self.likeButton setTitle:[NSString stringWithFormat:@"%llu", comment.likeCount] forState:UIControlStateNormal];
}

- (CGFloat)staticHeight {
    return 8        // top margin
    + 40            // profile btn heigh
    + 8             // profileBtn <-> contentLabel margin
    + 8             // contentLabel <-> likeBtn margin
    + 40            // likeBtn height
    + 8             // bottom margin
    ;
}

- (CGFloat)contentLabelHeightBy: (NSString*)string {
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = self.commentContentLabel.lineBreakMode;
    NSDictionary* attributes = @{NSFontAttributeName: self.contentLabelFont,
                                 NSParagraphStyleAttributeName: style};
    return [string boundingRectWithSize:self.commentContentLabel.frame.size
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:attributes
                         context:nil].size.height;
}

- (UIFont*)contentLabelFont {
    if (!_contentLabelFont) {
        _contentLabelFont = [UIFont systemFontOfSize: 17];
    }
    return _contentLabelFont;
}

- (CGFloat)heightWith:(QiuBaiComment *)comment {
    return [self staticHeight] + [self contentLabelHeightBy:comment.commentContent];
}

@end
