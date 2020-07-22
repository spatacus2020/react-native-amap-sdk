//
// Created by Allen Chiang on 16/3/17.
// Copyright (c) 2016 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (RNAIU_ToDictionary)

- (NSDictionary *)RNAIU_ToDictionary;

- (NSDictionary *)RNAIU_ToDictionaryWithDepth:(NSInteger)depth;
@end
