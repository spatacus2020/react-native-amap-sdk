//
// Created by Allen Chiang on 16/2/18.
// Copyright (c) 2016 terminus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum {
    RNAIU_CHAR, RNAIU_UNSIGNED_CHAR, RNAIU_SHORT, RNAIU_UNSIGNED_SHORT, RNAIU_INT, RNAIU_UNSIGNED, RNAIU_LONG, RNAIU_UNSIGNED_LONG,
    RNAIU_LONG_LONG, RNAIU_UNSIGNED_LONG_LONG, RNAIU_DOUBLE, RNAIU_FLOAT, RNAIU_C_BOOL,
    RNAIU_ID, RNAIU_STRUCT, RNAIU_FUNC, RNAIU_BLOCK, RNAIU_INT_P, RNAIU_VOID_P, RNAIU_CHAR_P, RNAIU_NIL
} RNAIU_TypeOfProperty;

@protocol RNAIUTransient
@end

@interface RNAPropertyAttributeInfo : NSObject
@property BOOL transient;
@property BOOL readOnly;
@property RNAIU_TypeOfProperty type;
@property Class clazz;
@property Class arrayClass;
@property(nonatomic, copy) NSString *dicPropertyName;
@property(nonatomic, copy) NSString *oriPropertyName;

@property SEL getter;
@property SEL setter;

@property(nonatomic, strong) NSArray *protocols;


+ (RNAPropertyAttributeInfo *)analyseProperty:(objc_property_t)pProperty
                                 WithClass:(Class)aClass
                       AndWithCurrentClass:(Class)currentClass;

+ (void)enumerateClassProperties:(Class)aClass
                   withInfoBlock:(void (^)(Class oriClass, Class currentClass, RNAPropertyAttributeInfo *info))infoBlock;

+ (id)getValue:(id)obj with:(RNAPropertyAttributeInfo *)info;

+ (NSArray *)getProtocolsFromClass:(Class)clazz;

@end


@interface RNAPropertyAttributeInfoCache : NSObject

+ (RNAPropertyAttributeInfoCache *)instance;

- (RNAPropertyAttributeInfo *)getFromCacheWithClass:(Class)clazz AndPropertyName:(NSString *)name;

- (void)putToCacheWithClass:(Class)clazz AndPropertyName:(NSString *)name WithInfo:(RNAPropertyAttributeInfo *)info;

@end

@interface RNAIUConvertDefine :NSObject

@end
