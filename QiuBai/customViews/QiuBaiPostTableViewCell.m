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
}
- (IBAction)tapToDislikePost:(id)sender {
}
- (IBAction)tapToCommentPost:(id)sender {
}
- (IBAction)tapToSharePost:(id)sender {
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //Font
    self.contentLabelFont = [UIFont systemFontOfSize:16];

    // content Label
    self.postContentLabel.numberOfLines = 0;
    self.postContentLabel.font = self.contentLabelFont;
    self.postContentLabel.textAlignment = NSTextAlignmentJustified;
    self.postContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setUpWith:(QiuBaiPost *)post {
    QiuBaiUser *author = post.postAuthor;

    [self.nickNameButton setTitle:author.nickName forState:UIControlStateNormal];

    self.postContentLabel.text = post.postContent;
    self.postInfoLable.text =
            [NSString stringWithFormat:@"好笑 %llu - 评论 %lu", post.likeCount, (unsigned long)post.comments.count];
}

- (CGFloat)heightWithPost:(QiuBaiPost*)post {

    CGFloat width = [self cellWidth];
     CGFloat MAX_CELL_HEIGHT = 9999;
    CGSize size = CGSizeMake(width, MAX_CELL_HEIGHT);
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary* attributesDictionary = @{
                                            NSFontAttributeName : self.contentLabelFont,
                                            NSParagraphStyleAttributeName: style};
    CGRect rect = [post.postContent boundingRectWithSize:size
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributesDictionary
                                   context:nil];
    return rect.size.height;
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
    return self.contentView.frame.size.width;
}
@end

