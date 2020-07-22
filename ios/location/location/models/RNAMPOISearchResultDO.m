//
// Created by Allen Chiang on 18/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <AMapSearchKit/AMapSearchKit.h>
#import "RNAMPOISearchResultDO.h"


@implementation RNAMPOI {
    AMapPOI *_aMapPOI;
}

- (instancetype)initWithAMapPOI:(AMapPOI *)aMapPOI {
    self = [super init];
    if (self) {
        _aMapPOI = [aMapPOI copy];
    }
    return self;
}

- (NSDictionary *)dictionary {
    if (_aMapPOI) {
        return @{
                @"uid": _aMapPOI.uid ?: @"",
                @"name": _aMapPOI.name ?: @"",
                @"type": _aMapPOI.type ?: @"",
                @"address": _aMapPOI.address ?: @"",
                @"adcode": _aMapPOI.adcode ?: @"",
                @"latitude": _aMapPOI.location.latitude?[NSString stringWithFormat:@"%f",_aMapPOI.location.latitude]:@"",
                @"longitude": _aMapPOI.location.longitude?[NSString stringWithFormat:@"%f",_aMapPOI.location.longitude]:@""
        };
    }
    return @{};
}


@end

@implementation RNAMPOISuggestion {
    AMapSuggestion *_suggestion;
}

- (instancetype)initWithAMapSuggestion:(AMapSuggestion *)suggestion {
    self = [super init];
    if (self) {
        _suggestion = [suggestion copy];
    }
    return self;
}

- (NSDictionary *)dictionary {
    if (_suggestion) {
        return @{
                @"keywords": _suggestion.keywords ?: @[]
        };
    }
    return @{};
}

@end

@implementation RNAMPOISearchResultDO

- (instancetype)initWithAMapPOISearchResponse:(AMapPOISearchResponse *)searchResponse {
    self = [super init];
    if (self) {
        _count = searchResponse.count;

        NSMutableArray *pois = [[NSMutableArray alloc] init];
        [searchResponse.pois enumerateObjectsUsingBlock:^(AMapPOI *aMapPOI, NSUInteger idx, BOOL *stop) {
            [pois addObject:[[[RNAMPOI alloc] initWithAMapPOI:aMapPOI] dictionary]];
        }];
        _pois = pois;
        _suggestions = [[RNAMPOISuggestion alloc] initWithAMapSuggestion:searchResponse.suggestion];
    }
    return self;
}

- (NSDictionary *)dictionary {
    return @{
            @"count": @(_count),
            @"pois": _pois ?: @[],
            @"suggestions": [_suggestions dictionary] ?: @{}
    };
}

@end
