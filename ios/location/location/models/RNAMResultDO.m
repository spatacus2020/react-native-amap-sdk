//
// Created by Allen Chiang on 18/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import "RNAMResultDO.h"
#import "RNAMLocationDO.h"

@implementation RNAMResultErrorDO

- (instancetype)initWithError:(NSError *)error {
    self = [super init];
    if (self) {
        _domain = error.domain;
        _code = error.code;
        _userInfo = error.userInfo;
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{
            @"domain": _domain ?: @"",
            @"code": @(_code),
            @"userInfo": _userInfo ?: @{}
    };
}

@end

@implementation RNAMResultDO

- (instancetype)initWithRequestId:(NSString *)requestId
                             data:(NSDictionary *)data {
    self = [super init];
    if (self) {
        _requestId = requestId;
        _data = data;
    }
    return self;
}

- (instancetype)initWithRequestId:(NSString *)requestId
                       locationDO:(RNAMLocationDO *)locationDO {
    return [self initWithRequestId:requestId data:[locationDO dictionary]];
}

- (instancetype)initWithRequestId:(NSString *)requestId
                            error:(NSError *)error {
    self = [super init];
    if (self) {
        _requestId = requestId;
        _error = [[RNAMResultErrorDO alloc] initWithError:error];
    }
    return self;
}


- (NSDictionary *)dictionary {
    if (_error) {
        return @{
                @"requestId": _requestId ?: @"",
                @"error": _error ? [_error dictionary] : @{}
        };
    }
    return @{
            @"requestId": _requestId ?: @"",
            @"data": _data ?: @{}
    };

}

@end