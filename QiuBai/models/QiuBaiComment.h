//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiuBaiDataObject.h"
@class QiuBaiUser;
@interface QiuBaiComment : QiuBaiDataObject
@property (nonatomic)           u_int64_t       commentID;
@property (strong, nonatomic)   QiuBaiUser *    commentAuthor;
@property (strong, nonatomic)   NSString *      commentContent;
@property (strong, nonatomic)   NSMutableArray  *respondCommentIDs;
@property (strong, nonatomic)   NSMutableSet    *respondComments;
@property (nonatomic)           u_int64_t       likeCount;

- (instancetype)initWithJSONDictionary:(NSDictionary *)dictionary;
@end