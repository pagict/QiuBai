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
- (void)didFinishedCommentEditing:(UITextView*)textView;
@end

@interface EditCommentView : UIView
@property (weak, nonatomic) id<EditCommentViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton* emojiButton;
@property (strong, nonatomic) IBOutlet UITextView* editingTextView;
@property (strong, nonatomic) IBOutlet UIButton* commentButton;
- (void)beginEditComment;
@end
