//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@class CLLocation;


@interface RNAMLocationDO : NSObject

//// gps坐标信息
@property(nonatomic, assign) double latitude;

@property(nonatomic, assign) double longitude;

///格式化地址
@property(nonatomic, copy) NSString *formattedAddress;

///国家
@property(nonatomic, copy) NSString *country;

///省/直辖市
@property(nonatomic, copy) NSString *province;

///市
@property(nonatomic, copy) NSString *city;

///区
@property(nonatomic, copy) NSString *district;

///城市编码
@property(nonatomic, copy) NSString *citycode;

///区域编码
@property(nonatomic, copy) NSString *adcode;

///街道名称
@property(nonatomic, copy) NSString *street;

///门牌号
@property(nonatomic, copy) NSString *number;

///兴趣点名称
@property(nonatomic, copy) NSString *POIName;

///所属兴趣点名称
@property(nonatomic, copy) NSString *AOIName;

// poi列表
@property(nonatomic, copy) NSArray *pois;
@property(nonatomic, copy) NSArray *aois;


- (id)initWithCLLocation:(CLLocation *)location
                     withReGeocode:(AMapLocationReGeocode *)reGeocode;

- (id)initWithGeocode:(AMapGeocode *)mapGeocode;

- (id)initWithReGeocode:(AMapReGeocode *)mapReGeocode;

- (NSDictionary *)dictionary;
@end
