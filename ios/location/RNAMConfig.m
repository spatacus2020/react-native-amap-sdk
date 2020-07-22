//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <AMapFoundationKit/AMapFoundationKit.h>
#import "RNAMConfig.h"

@implementation RNAMConfig

+ (void)setAppKey:(NSString *)appKey {
    [AMapServices sharedServices].enableHTTPS = YES;
    NSAssert(appKey, @"RNAMConfig.setAppKey appKey can not be nil");
    [AMapServices sharedServices].apiKey = appKey;
}

+ (instancetype)shareInstance {
    static dispatch_once_t once_t;
    static RNAMConfig *shareInstance;
    dispatch_once(&once_t, ^{
        if (!shareInstance) {
            shareInstance = [[RNAMConfig alloc] init];
        }
    });
    return shareInstance;
}


@end
