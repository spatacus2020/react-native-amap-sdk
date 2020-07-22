//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <AMapSearchKit/AMapSearchKit.h>
#import <React/RCTBridgeModule.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "RNAMGeocodeManager.h"
#import "AMapSearchObject+RNAMRequest.h"
#import "RNAMLocationDO.h"
#import "RNAMResultDO.h"
#import "RNAMPOISearchResultDO.h"
#import "RNAMLocationManager.h"
#import "RNAMDistrictSearchReultDO.h"

static NSString *const kRNAMGeocodeEventNameGeocode = @"geocode";
static NSString *const kRNAMGeocodeEventRequestId = @"requestId";

@interface RNAMGeocodeManager () <AMapSearchDelegate>

@end

@implementation RNAMGeocodeManager {
    AMapSearchAPI *_searchAPI;
    RNAMLocationManager *_locationManager;
}

@synthesize bridge = _bridge;

- (instancetype)init {
    self = [super init];
    if (self) {
        _searchAPI = [[AMapSearchAPI alloc] init];
        [_searchAPI setDelegate:self];
    }
    return self;
}


- (void)requestGeocode:(NSString *)requestId
           withAddress:(NSString *)address
              withCity:(NSString *)city {
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = address;
    geo.city = city;
    geo.requestId = requestId;
    [_searchAPI AMapGeocodeSearch:geo];
}

- (void)requestReGeocode:(NSString *)requestId
            withLatitude:(NSString *)latitude
           withLongitude:(NSString *)longitude {

    AMapGeoPoint *geoPoint = [[AMapGeoPoint alloc] init];
    [geoPoint setLatitude:[latitude floatValue]];
    [geoPoint setLongitude:[longitude floatValue]];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    [regeo setLocation:geoPoint];
    [regeo setRequireExtension:YES];
    [regeo setRequestId:requestId];
    [_searchAPI AMapReGoecodeSearch:regeo];
}

- (void)requestPOISearch:(NSString *)requestId
            withKeywords:(NSString *)keywords
                withCity:(NSString *)cityCode {
    [self requestPOISearchWithPage:requestId
                      withKeywords:keywords
                          withCity:cityCode
                       withPageNum:0
                      withPageSize:10];
}

- (void)requestPOISearchWithPage:(NSString *) requestId
                    withKeywords:(NSString *) keywords
                        withCity:(NSString *) cityCode
                     withPageNum:(NSInteger) pageNum
                    withPageSize:(NSInteger) pageSize{
    if (!cityCode || cityCode.length == 0) {
        // 没有传入cityCode，需要手动获取一次定位
        [self requestPOISearchLiteWithPage:requestId
                              withKeywords:keywords
                               withPageNum:pageNum
                              withPageSize:pageSize];
        return;
    }
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    [request setKeywords:keywords];
    [request setCityLimit:YES];
    [request setRequireSubPOIs:YES];
    [request setRequestId:requestId];
    [request setPage:pageNum];
    [request setCity:cityCode];
    [request setOffset:pageSize];
    [request setCityLimit:YES];
    [request setRequireExtension:YES];
    [_searchAPI AMapPOIKeywordsSearch:request];
}

- (void)requestPOISearchLiteWithPage:(NSString *)requestId
                        withKeywords:(NSString *)keywords
                         withPageNum:(NSInteger)pageNum
                        withPageSize:(NSInteger)pageSize {
    if(!_locationManager){
        _locationManager = [[RNAMLocationManager alloc] init];
    }
    __weak __typeof(self) weakSelf = self;
    [[_locationManager locationManager] requestLocationWithReGeocode:YES
                                                    completionBlock:^(CLLocation *location, AMapLocationReGeocode *reGeocode, NSError *error) {
                                                        if (error) {
                                                            NSLog(@"locError:{%ld - %@};", (long) error.code, error.localizedDescription);

                                                            RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:requestId
                                                                                                                       error:error];
                                                            [weakSelf sendEventWithName:kRNAMGeocodeEventNameGeocode
                                                                                   body:[resultDO dictionary]];
                                                            return;
                                                        }

                                                        [weakSelf requestPOISearchWithPage:requestId
                                                                              withKeywords:keywords
                                                                                  withCity:reGeocode.citycode
                                                                               withPageNum:pageNum
                                                                              withPageSize:pageSize];
                                                    }];
}


- (void)requestDistrictSearch:(NSString *)requestId
                         name:(NSString *)name {
    
    AMapDistrictSearchRequest *request = [[AMapDistrictSearchRequest alloc] init];
    request.requestId = requestId;
    request.keywords = name;
    request.requireExtension = YES;
    [_searchAPI AMapDistrictSearch:request];
}

#pragma mark - AMapSearchDelegate

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request
                   response:(AMapGeocodeSearchResponse *)response {
    NSMutableArray *geocodeArray = [[NSMutableArray alloc] init];
    [response.geocodes enumerateObjectsUsingBlock:^(AMapGeocode *aMapGeocode, NSUInteger idx, BOOL *stop) {
        [geocodeArray addObject:[[[RNAMLocationDO alloc] initWithGeocode:aMapGeocode] dictionary]];
    }];
    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:request.requestId
                                                                data:@{@"list": geocodeArray}];
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode body:[resultDO dictionary]];

}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request
                     response:(AMapReGeocodeSearchResponse *)response {
    RNAMLocationDO *location = [[RNAMLocationDO alloc] initWithReGeocode:response.regeocode];

    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:request.requestId
                                                          locationDO:location];
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode
                       body:[resultDO dictionary]];
}

- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request
               response:(AMapPOISearchResponse *)response {
    RNAMPOISearchResultDO *searchResultDO = [[RNAMPOISearchResultDO alloc] initWithAMapPOISearchResponse:response];
    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:request.requestId data:[searchResultDO dictionary]];
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode body:[resultDO dictionary]];
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response {
    
    
    RNAMDistrictSearchReultDO *district = [[RNAMDistrictSearchReultDO alloc] initWithAMapDistrictSearchResponse:response.districts.firstObject];
    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:request.requestId data:[district dictionary]];
    
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode body:[resultDO dictionary]];
}

- (void)AMapSearchRequest:(id)request
         didFailWithError:(NSError *)error {
    AMapSearchObject *searchRequest = [request isKindOfClass:[AMapSearchObject class]] ? request : nil;
    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:searchRequest.requestId
                                                               error:error];
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode
                       body:[resultDO dictionary] ];
}

- (void)sendReactEvent:(NSString *)requestId withData:(id)data {
    RNAMLocationDO *location = nil;
    if([data isKindOfClass:[AMapGeocode class]]){
        location = [[RNAMLocationDO alloc] initWithGeocode:data];
    }
    else if([data isKindOfClass:[AMapReGeocode class]]){
        location = [[RNAMLocationDO alloc] initWithReGeocode:data];
    }
    RNAMResultDO *resultDO = [[RNAMResultDO alloc] initWithRequestId:requestId
                                                          locationDO:location];
    [self sendEventWithName:kRNAMGeocodeEventNameGeocode
                       body:[resultDO dictionary]];
}

#pragma mark - Export to React Native Method

RCT_EXPORT_MODULE(RNGeocodeManager);

- (NSArray<NSString *> *)supportedEvents {
    return @[kRNAMGeocodeEventNameGeocode];
}

- (dispatch_queue_t)methodQueue {
    return dispatch_queue_create("io.terminus.react.native.geo.location", DISPATCH_QUEUE_SERIAL);
}

RCT_EXPORT_METHOD(geocode:(NSString *) requestId
              withAddress:(NSString *) address
                 withCity:(NSString *) city) {
    [self requestGeocode:requestId withAddress:address withCity:city];
}

RCT_EXPORT_METHOD(reGeocode:(NSString *) requestId
               withLatitude:(NSString *) latitude
              withLongitude:(NSString *) longitude) {
    [self requestReGeocode:requestId
              withLatitude:latitude
             withLongitude:longitude];
}

RCT_EXPORT_METHOD(poiSearch:(NSString *) requestId
               withKeywords:(NSString *) keywords
                   withCity:(NSString *) cityCode) {
    [self requestPOISearch:requestId
              withKeywords:keywords
                  withCity:cityCode];
}

RCT_EXPORT_METHOD(poiSearchWithPage:(NSString*) requestId
                       withKeywords:(NSString *) keywords
                           withCity:(NSString *) cityCode
                        withPageNum:(NSInteger) pageNum
                       withPageSize:(NSInteger) pageSize){
  [self requestPOISearchWithPage:requestId
                    withKeywords:keywords
                        withCity:cityCode
                     withPageNum:pageNum
                    withPageSize:pageSize];
}


RCT_EXPORT_METHOD(district:(NSString *) requestId
                      name:(NSString *)name) {

    [self requestDistrictSearch:requestId name:name];
}



@end
