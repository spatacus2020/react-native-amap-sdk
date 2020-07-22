//
//  RNAMDistrictSearchReultDO.m
//  Pods
//
//  Created by Wenbo Li on 2017/7/11.
//
//

#import "RNAMDistrictSearchReultDO.h"

@implementation RNAMDistrictSearchReultDO

- (instancetype)initWithAMapDistrictSearchResponse:(AMapDistrict *)district {

    self = [super init];
    if (self) {
        
        id adcode = district.adcode;
        id center = district.center;
        
        if ([adcode isKindOfClass:[NSString class]]) {
            self.adCode = adcode;
        }
        if ([center isKindOfClass:[AMapGeoPoint class]]) {
            self.latitude = [(AMapGeoPoint *)center latitude];
            self.longitude = [(AMapGeoPoint *)center longitude];
        }
    }
    return self;
}

- (NSDictionary *)dictionary {
    
    if (self.adCode) {
        return @{
                 @"adCode": self.adCode?self.adCode:@"",
                 @"latitude": @(self.latitude),
                 @"longitude": @(self.longitude),
                 };
    }
    return @{};
}


@end
