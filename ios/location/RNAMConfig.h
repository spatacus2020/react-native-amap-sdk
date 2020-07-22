//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RNAMConfig : NSObject

/**
 * 当前app的scheme，用于高德导航唤起以后的回调
 */
@property(nonatomic, copy) NSString *appScheme;

/**
 * 高德的appKey
 * @param appKey
 */
+ (void)setAppKey:(NSString *)appKey;


+ (instancetype)shareInstance;

@end