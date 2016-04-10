//
//  EditCommentView.h
//  QiuBai
//
//  Created by PengPremium on 16/4/8.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditCommentViewDelegate <UITextViewDelegate>
@required
//@property (strong, nonatomic) NSAttributedString* commentContent;
@end

@interface EditCommentView : UIView
@property (weak, nonatomic) id<EditCommentViewDelegate> delegate;
@end
