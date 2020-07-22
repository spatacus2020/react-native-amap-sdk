//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "RNAMLocationDO.h"
#import "RNAMPOISearchResultDO.h"


@implementation RNAMLocationDO

- (instancetype)initWithCLLocation:(CLLocation *)location
                     withReGeocode:(AMapLocationReGeocode *)reGeocode {
    self = [super init];
    if (self) {
        _latitude = location.coordinate.latitude;
        _longitude = location.coordinate.longitude;
        if (reGeocode) {
            _formattedAddress = reGeocode.formattedAddress;
            _country = reGeocode.country;
            _province = reGeocode.province;
            _city = reGeocode.city;
            _district = reGeocode.district;
            _citycode = reGeocode.citycode;
            _adcode = reGeocode.adcode;
            _street = reGeocode.street;
            _number = reGeocode.number;
            _POIName = reGeocode.POIName;
            _AOIName = reGeocode.AOIName;
        }
    }
    return self;
}

- (id)initWithGeocode:(AMapGeocode *)mapGeocode {
    self = [super init];
    if(self){
        _formattedAddress = mapGeocode.formattedAddress;
        _country = mapGeocode.township;
        _province = mapGeocode.province;
        _city = mapGeocode.city;
        _district = mapGeocode.district;
        _citycode = mapGeocode.citycode;
        _adcode = mapGeocode.adcode;

        _latitude = mapGeocode.location.latitude;
        _longitude = mapGeocode.location.longitude;
    }
    return self;
}


- (id)initWithReGeocode:(AMapReGeocode *)mapReGeocode {
    self = [super init];
    if (self) {
        _formattedAddress = mapReGeocode.formattedAddress;
        AMapAddressComponent *addressComponent = mapReGeocode.addressComponent;
        AMapStreetNumber *streetNumber = addressComponent.streetNumber;
        _country = addressComponent.township;
        _province = addressComponent.province;
        _citycode = addressComponent.citycode;
        _city = addressComponent.city;
        _district = addressComponent.district;
        _adcode = addressComponent.adcode;

        _street = streetNumber.street;
        _number = streetNumber.number;
        _latitude = streetNumber.location.latitude;
        _longitude = streetNumber.location.longitude;
    
        if(mapReGeocode.pois){
            NSMutableArray *pois = [[NSMutableArray alloc] init];
            
            [mapReGeocode.pois  enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull aMapPOI, NSUInteger idx, BOOL * _Nonnull stop) {
                if(aMapPOI.adcode){
                    aMapPOI.adcode = addressComponent.adcode;
                }
                RNAMPOI *poiDO = [[RNAMPOI alloc] initWithAMapPOI:aMapPOI];
                [pois addObject:[poiDO dictionary]];
            }];
            _pois = pois;
        }
        
        if(mapReGeocode.aois){
            NSMutableArray *aois = [[NSMutableArray alloc] init];
            [mapReGeocode.aois  enumerateObjectsUsingBlock:^(AMapAOI * _Nonnull aMapPOI, NSUInteger idx, BOOL * _Nonnull stop) {
                [aois addObject: [aMapPOI name]];
            }];
            _aois = aois;
        }
    }
    return self;
}


- (NSDictionary *)dictionary {
    return @{
            @"latitude": [NSString stringWithFormat:@"%f", _latitude],
            @"longitude": [NSString stringWithFormat:@"%f", _longitude],
            @"formattedAddress": _formattedAddress?:@"",
            @"country": _country?:@"",
            @"province": _province?:@"",
            @"city": _city?:@"",
            @"district": _district?:@"",
            @"cityCode": _citycode?:@"",
            @"adCode": _adcode?:@"",
            @"street": _street?:@"",
            @"number": _number?:@"",
            @"POIName": _POIName?:@"",
            @"AOIName": _AOIName?:@"",
            @"pois": _pois?:@{},
            @"aois": _aois?:@{}
    };
}


@end
