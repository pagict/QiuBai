//
//  DataLoader.m
//  QiuBai
//
//  Created by PengPremium on 16/3/29.
//  Copyright © 2016年 pi-lot.org. All rights reserved.
//

#import "DataLoader.h"
#import "QiuBaiUser.h"
#import "ModelStore.h"
#import "QiuBaiPost.h"
#import "QiuBaiComment.h"

@implementation DataLoader
+ (void)loadUsers {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"users" ofType:@"json"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    NSArray *usersArray = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];
    ModelStore *store = [ModelStore sharedStore];
    for(NSDictionary *dictionary in usersArray) {
        [store insertUser:[[QiuBaiUser alloc] initWithJSONDictionary:dictionary]];
    }
}

+ (void)loadPosts {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"posts" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *postArray = [NSJSONSerialization JSONObjectWithData:data
                                                         options:0
                                                           error:nil];
    ModelStore *store = [ModelStore sharedStore];
    for(NSDictionary *dictionary in postArray) {
        [store insertPost:[[QiuBaiPost alloc] initWithJSONDictionary:dictionary]];
    }
}

+ (void)loadComments {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"comments" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *commentArray = [NSJSONSerialization JSONObjectWithData:data
                                                            options:0
                                                              error:nil];
    ModelStore *store = [ModelStore sharedStore];
    for(NSDictionary *dictionary in commentArray) {
        [store insertComment:[[QiuBaiComment alloc] initWithJSONDictionary:dictionary]];
    }
}

+ (void)loadData {
    [DataLoader loadUsers];
    [DataLoader loadComments];
    [DataLoader loadPosts];
}


@end
