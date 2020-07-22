//
// Created by Allen Chiang on 18/01/2017.
// Copyright (c) 2017 Facebook. All rights reserved.
//

#import <objc/runtime.h>
#import "AMapSearchObject+RNAMRequest.h"

@implementation AMapSearchObject (RNAMRequest)
- (void)setRequestId:(NSString *)requestId
{
    objc_setAssociatedObject(self, @selector(requestId), requestId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)requestId
{
    return  objc_getAssociatedObject(self, @selector(requestId));
}
@end