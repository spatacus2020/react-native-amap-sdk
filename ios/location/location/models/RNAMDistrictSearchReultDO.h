//
//  RNAMDistrictSearchReultDO.h
//  Pods
//
//  Created by Wenbo Li on 2017/7/11.
//
//

#import <Foundation/Foundation.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface RNAMDistrictSearchReultDO : NSObject

@property(nonatomic, assign) double latitude;

@property(nonatomic, assign) double longitude;

@property(nonatomic, copy) NSString *adCode;


- (instancetype)initWithAMapDistrictSearchResponse:(AMapDistrict *)district;


- (NSDictionary *)dictionary;

@end
