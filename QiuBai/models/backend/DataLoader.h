//
//  DataLoader.h
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import <Foundation/Foundation.h>


@class QiuBaiUser;

@interface DataLoader : NSObject
+ (void)loadUsers;
+ (void)loadPosts;
+ (void)loadComments;
+ (void)loadData;
@end
