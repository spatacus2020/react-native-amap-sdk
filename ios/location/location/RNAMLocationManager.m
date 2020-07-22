//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <AMapLocationKit/AMapLocationKit.h>
#import "RCTBridgeModule.h"
#import "RNAMLocationManager.h"
#import "RNAMLocationDO.h"
#import "RNAMResultDO.h"

NSString *const kRNAMLocationErrorCode_AuthorizeDeny = @"authorized_deny";


NSString *const kRNAMLocationErrorMessage_AuthorizeDeny = @"请开启定位权限";

@implementation RNAMLocationManager {
    AMapLocationManager *_locationManager;
}
@synthesize bridge = _bridge;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self locationManager];
    }
    return self;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        AMapLocationManager *locationManager = [[AMapLocationManager alloc] init];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [locationManager setLocationTimeout:2]; // timeout 2 seconds
        [locationManager setReGeocodeTimeout:2]; // 逆地理位置 timeout 2 seconds
        _locationManager = locationManager;
    }
    return _locationManager;
}

- (BOOL)hasAuthorized {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse
            || status == kCLAuthorizationStatusNotDetermined);
}

- (void)requestLocationResolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject {
    // 判断定位权限
    if (![self hasAuthorized]) {
        reject(kRNAMLocationErrorCode_AuthorizeDeny, kRNAMLocationErrorMessage_AuthorizeDeny,
                [NSError errorWithDomain:kRNAMLocationErrorCode_AuthorizeDeny code:0 userInfo:nil]);
        return;
    }

    RCTPromiseResolveBlock resolveCopy = [resolve copy];
    RCTPromiseRejectBlock rejectCopy = [reject copy];
    [_locationManager requestLocationWithReGeocode:YES
                                   completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                       if (error) {
                                           NSLog(@"locError:{%ld - %@};", (long) error.code, error.localizedDescription);

                                           if (rejectCopy) {
                                               rejectCopy([NSString stringWithFormat:@"%d", error.code], error.localizedDescription, error);
                                           }
                                           return;
                                       }

                                       RNAMLocationDO *locationDO = [[RNAMLocationDO alloc] initWithCLLocation:location
                                                                                                 withReGeocode:regeocode];
                                       RNAMResultDO *resultDO = [[RNAMResultDO alloc] init];
                                       [resultDO setData:[locationDO dictionary]];
                                       if (resolveCopy) {
                                           resolveCopy([resultDO dictionary]);
                                       }

                                   }];
}

#pragma mark - Export to React Native

RCT_EXPORT_MODULE(RNLocationManager);

RCT_REMAP_METHOD(location,
            resolver:
            (RCTPromiseResolveBlock) resolve
            rejecter:
            (RCTPromiseRejectBlock) reject) {
    [self requestLocationResolver:resolve rejecter:reject];
}

@end
