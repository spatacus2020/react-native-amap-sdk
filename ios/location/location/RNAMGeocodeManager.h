//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>


@interface RNAMGeocodeManager : RCTEventEmitter <RCTBridgeModule>

/**
 * 地理编码查询，根据地址信息查询GPS
 * @param requestId 请求id
 * @param address 详细地址
 * @param city 城市名称，中文，英文，或者城市编码均可，非必填项
 */
- (void)requestGeocode:(NSString *)requestId
           withAddress:(NSString *)address
              withCity:(NSString *)city;

/**
 * 逆地理编码查询，根据GPS查询详细地址信息
 * @param requestId 请求id
 * @param latitude 维度
 * @param longitude 经度
 */
- (void)requestReGeocode:(NSString *)requestId
            withLatitude:(NSString *)latitude
           withLongitude:(NSString *)longitude;

/**
 * 检索POI信息
 * @param requestId 请求id
 * @param keywords POI的搜索关键字
 * @param cityCode 城市编码，如果不传会自动获取当前定位所在的citycode
 */
- (void)requestPOISearch:(NSString *)requestId
            withKeywords:(NSString *)keywords
                withCity:(NSString *)cityCode;


/**
 * 获取行政区划数据
 * @param requestId 请求id
 * @param name 地区名称
 */
- (void)requestDistrictSearch:(NSString *)requestId
                         name:(nullable NSString *)name;



@end
