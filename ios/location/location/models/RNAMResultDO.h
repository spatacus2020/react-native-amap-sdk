//
// Created by Allen Chiang on 18/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNAMLocationDO.h"


@interface RNAMResultErrorDO : NSObject

@property(nonatomic, copy) NSString *domain;
@property(nonatomic, assign) NSInteger code;
@property(nonatomic, copy) NSDictionary *userInfo;

- (instancetype)initWithError:(NSError *)error;

- (NSDictionary *)dictionary;
@end


@interface RNAMResultDO : NSObject

@property(nonatomic, copy) NSString *requestId;
@property(nonatomic, copy) NSDictionary *data;
@property(nonatomic, copy) RNAMResultErrorDO *error;

- (instancetype)initWithRequestId:(NSString *)requestId
                             data:(NSDictionary *)data;

- (instancetype)initWithRequestId:(NSString *)requestId
                       locationDO:(RNAMLocationDO *)locationDO;

- (instancetype)initWithRequestId:(NSString *)requestId
                            error:(NSError *)error;

- (NSDictionary *)dictionary;
@end