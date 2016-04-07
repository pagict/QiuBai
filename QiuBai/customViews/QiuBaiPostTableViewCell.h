//
//  QiuBaiPostTableViewCell.h
//  QiuBai
//
//  Created by PengPremium on 16/3/31.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QiuBaiPost;

@interface QiuBaiPostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView * _Nullable profileImageView;

@property (weak, nonatomic) IBOutlet UIButton * _Nullable nickNameButton;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable postContentLabel;
@property (weak, nonatomic) IBOutlet UILabel * _Nullable postInfoLable;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable likeButton;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable dislikeButtn;
@property (weak, nonatomic) IBOutlet UIButton * _Nullable addCommentButton;

@property (strong, nonatomic) UIFont* contentLabelFont;
@property (strong, nonatomic) UIFont* infoLabelFont;

- (void)setUpWith:(nullable QiuBaiPost*)post;
- (CGFloat)heightWithPost:(nullable QiuBaiPost*)post;
- (CGFloat)staticHeight;
- (CGFloat)cellWidth;
@end
