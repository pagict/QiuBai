//
// Created by PengPremium on 16/3/29.
// Copyright (c) 2016 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QiuBaiUser.h"

@interface QiuBaiPost : NSObject
@property (nonatomic)                   u_int64_t       postID;
@property (strong, nonatomic)           QiuBaiUser *    postAuthor;
@property (strong, nonatomic)           NSString *      postContent;
@property (strong, nonatomic)           NSDate *        postDate;
@property (nonatomic)                   u_int64_t       likeCount;
@property (nonatomic)                   u_int64_t       dislikeCount;
@property (nonatomic)                   u_int64_t       sharedCount;
@property (strong, nonatomic)           NSMutableArray *comments;

@property (nonatomic, getter=isHot)     BOOL            hot;
@property (nonatomic, getter=isNew)     BOOL            newPost;

- (instancetype)initWithJSONDictionary:(NSDictionary *)attributeDictionary;
@end