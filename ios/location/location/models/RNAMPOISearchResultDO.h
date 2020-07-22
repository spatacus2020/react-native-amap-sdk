//
// Created by Allen Chiang on 18/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface RNAMPOI : NSObject

- (instancetype)initWithAMapPOI:(AMapPOI *)aMapPOI;

- (NSDictionary *)dictionary;
@end

@interface RNAMPOISuggestion : NSObject

- (instancetype)initWithAMapSuggestion:(AMapSuggestion *)suggestion;

- (NSDictionary *)dictionary;
@end

@interface RNAMPOISearchResultDO : NSObject

@property(nonatomic, copy) NSArray *pois;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, copy) RNAMPOISuggestion *suggestions;

- (instancetype)initWithAMapPOISearchResponse:(AMapPOISearchResponse *)searchResponse;

- (NSDictionary *)dictionary;
@end