//
// Created by Allen Chiang on 17/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

@interface RNAMLocationManager : NSObject <RCTBridgeModule>

/**
 * 初始化一个AMapLocationManager
 * @return AMapLocationManager
 */
- (AMapLocationManager *)locationManager;

/**
 * 定位当前位置
 */
- (void)requestLocationResolver:(RCTPromiseResolveBlock)resolve
                       rejecter:(RCTPromiseRejectBlock)reject;
@end
