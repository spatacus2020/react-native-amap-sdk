//
// Created by Allen Chiang on 16/2/18.
// Copyright (c) 2016 terminus. All rights reserved.
//

#import <objc/message.h>
#import "RNAIUConvertDefine.h"
#import <libextobjc/extobjc.h>


@implementation RNAPropertyAttributeInfoCache {
@private
    NSCache *_cache;
}

- (id)init {
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    return self;
}

- (void)dealloc {
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#endif
}

+ (RNAPropertyAttributeInfoCache *)instance {
    static RNAPropertyAttributeInfoCache *_instance = nil;
    static dispatch_once_t _oncePredicate_PropertyAttributeInfoCache;

    dispatch_once(&_oncePredicate_PropertyAttributeInfoCache, ^{
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    );

    return _instance;
}

- (RNAPropertyAttributeInfo *)getFromCacheWithClass:(Class)clazz
                                   AndPropertyName:(NSString *)name {
    @synchronized (self) {
        NSDictionary *proInfos = [_cache objectForKey:NSStringFromClass(clazz)];
        if (proInfos) {
            RNAPropertyAttributeInfo *info = [proInfos objectForKey:name];
            return info;
        }
        return nil;
    }
}

- (void)putToCacheWithClass:(Class)clazz AndPropertyName:(NSString *)name
                   WithInfo:(RNAPropertyAttributeInfo *)info {
    @synchronized (self) {
        NSMutableDictionary *proInfos = [_cache objectForKey:NSStringFromClass(clazz)];
        if (proInfos == nil) {
            proInfos = [[NSMutableDictionary alloc] initWithCapacity:1];
            [_cache setObject:proInfos
                       forKey:NSStringFromClass(clazz)];
        }
        [proInfos setObject:info
                     forKey:name];
    }
}

- (void)clearCache {
    @synchronized (self) {
        [_cache removeAllObjects];
    }
}

@end

@implementation RNAPropertyAttributeInfo   {
@private
    BOOL _transient;
    BOOL _readOnly;
    RNAIU_TypeOfProperty _type;
    Class _clazz;
    Class _arrayClass;
    NSString *_dicPropertyName;
    NSString *_oriPropertyName;
    SEL _getter;
    SEL _setter;
    NSArray *_protocols;
}

@synthesize transient = _transient;
@synthesize readOnly = _readOnly;
@synthesize type = _type;
@synthesize clazz = _clazz;
@synthesize arrayClass = _arrayClass;
@synthesize dicPropertyName = _dicPropertyName;
@synthesize oriPropertyName = _oriPropertyName;

@synthesize getter = _getter;
@synthesize setter = _setter;

@synthesize protocols = _protocols;

+ (RNAPropertyAttributeInfo *)analyseProperty:(objc_property_t)pProperty
                                   WithClass:(Class)aClass 
                         AndWithCurrentClass:(Class)currentClass {
    NSMutableString *propertyName = [NSMutableString stringWithUTF8String:property_getName(pProperty)];
    RNAPropertyAttributeInfo *info;
    if ((info = [[RNAPropertyAttributeInfoCache instance] getFromCacheWithClass:aClass
                                                             AndPropertyName:propertyName]) != nil) {
        return info;
    }

    ext_propertyAttributes* pAttributes = ext_copyPropertyAttributes(pProperty);
    if (NULL == pAttributes) {
        return nil;
    }
    RNAIU_TypeOfProperty typeOfProperty = RNAIU_NIL;
    Class clazz = nil;
    BOOL transient = NO;
    BOOL readOnly = pAttributes->readonly;
    Class arrayClass = nil;
    NSMutableArray *protocols = [[NSMutableArray alloc] initWithCapacity:2];
    NSString *dicPropertyName = propertyName;
    NSString *typeAtt = [NSString stringWithCString:pAttributes->type
                                           encoding:NSUTF8StringEncoding];
    if ([typeAtt hasPrefix:@"c"]) {
        typeOfProperty = RNAIU_CHAR;
    } else if ([typeAtt hasPrefix:@"C"]) {
        typeOfProperty = RNAIU_UNSIGNED_CHAR;
    } else if ([typeAtt hasPrefix:@"B"]) {
        typeOfProperty = RNAIU_C_BOOL;
    } else if ([typeAtt hasPrefix:@"d"]) {
        typeOfProperty = RNAIU_DOUBLE;
    } else if ([typeAtt hasPrefix:@"i"]) {
        typeOfProperty = RNAIU_INT;
    } else if ([typeAtt hasPrefix:@"f"]) {
        typeOfProperty = RNAIU_FLOAT;
    } else if ([typeAtt hasPrefix:@"l"]) {
        typeOfProperty = RNAIU_LONG;
    } else if ([typeAtt hasPrefix:@"L"]) {
        typeOfProperty = RNAIU_UNSIGNED_LONG;
    } else if ([typeAtt hasPrefix:@"q"]) {
        typeOfProperty = RNAIU_LONG_LONG;
    } else if ([typeAtt hasPrefix:@"Q"]) {
        typeOfProperty = RNAIU_UNSIGNED_LONG_LONG;
    } else if ([typeAtt hasPrefix:@"s"]) {
        typeOfProperty = RNAIU_SHORT;
    } else if ([typeAtt hasPrefix:@"S"]) {
        typeOfProperty = RNAIU_UNSIGNED_SHORT;
    } else if ([typeAtt hasPrefix:@"{"]) {
        typeOfProperty = RNAIU_STRUCT;
    } else if ([typeAtt hasPrefix:@"I"]) {
        typeOfProperty = RNAIU_UNSIGNED;
    } else if ([typeAtt hasPrefix:@"^i"]) {
        typeOfProperty = RNAIU_INT_P;
    } else if ([typeAtt hasPrefix:@"^v"]) {
        typeOfProperty = RNAIU_VOID_P;
    } else if ([typeAtt hasPrefix:@"^?"]) {
        typeOfProperty = RNAIU_FUNC;
    } else if ([typeAtt hasPrefix:@"*"]) {
        typeOfProperty = RNAIU_CHAR_P;
    } else if ([typeAtt hasPrefix:@"@"]) {
        if ([typeAtt hasSuffix:[NSString stringWithCString:@encode(void (^)())
                                                  encoding:NSUTF8StringEncoding]]) {
            typeOfProperty = RNAIU_BLOCK;
        } else {
            typeOfProperty = RNAIU_ID;
            clazz = pAttributes->objectClass;
            NSString *propertyType = nil;
            NSString *arrayClassName;
            NSString *attrStrForScan = typeAtt;
            const char *const attrString = property_getAttributes(pProperty);
            if (attrString) {                           //兼容iOS5 原来在iOS5 上NSGetSizeAndAlignment有bug 导致取出的typeAtt不对
                attrStrForScan = @(attrString + 1);
            }
            NSScanner *scanner = [NSScanner scannerWithString:attrStrForScan];
            if ([scanner scanString:@"@\""
                         intoString:&propertyType]) {
                [scanner scanUpToCharactersFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<"]
                                        intoString:&propertyType];
                if (!clazz) {
                    clazz = NSClassFromString(propertyType);
                }

                while ([scanner scanString:@"<"
                                intoString:NULL]) {

                    NSString *protocolName = nil;

                    [scanner scanUpToString:@">"
                                 intoString:&protocolName];

                    if (protocolName) {
                        [protocols addObject:protocolName];
                    }

                    if ([protocolName isEqualToString:NSStringFromProtocol(@protocol(RNAIUTransient))]) {
                        transient = YES;
                    } else {
                        arrayClassName = protocolName;
                    }

                    [scanner scanString:@">"
                             intoString:NULL];
                }

            }


            if ([clazz isSubclassOfClass:[NSArray class]] || [clazz isSubclassOfClass:[NSSet class]]) {
                if (arrayClassName) {
                    arrayClass = NSClassFromString(arrayClassName);
                }
            }
        }
    }

    info = [[RNAPropertyAttributeInfo alloc] init];
    info.readOnly = readOnly;
    info.clazz = clazz;
    info.type = typeOfProperty;
    info.arrayClass = arrayClass;
    info.dicPropertyName = dicPropertyName;
    info.oriPropertyName = propertyName;
    info.transient = [propertyName hasPrefix:@"_"] || transient;
    info.setter = pAttributes->setter;
    info.getter = pAttributes->getter;
    info.protocols = protocols;
    [[RNAPropertyAttributeInfoCache instance]
            putToCacheWithClass:aClass
                AndPropertyName:propertyName
                       WithInfo:info];
    if (pAttributes != NULL) {
        free(pAttributes);
    }
    return info;

}

+ (void)enumerateClassProperties:(Class)aClass
                   withInfoBlock:(void (^)(Class oriClass, Class currentClass, RNAPropertyAttributeInfo *info))infoBlock {
    if (!infoBlock) {
        return;
    }
    Class clazz = aClass;
    while (clazz != nil) {
        if (clazz == [NSObject class]) {
            break;
        }
        unsigned int propertyCount;
        objc_property_t *pProperty = class_copyPropertyList(clazz, &propertyCount);
        if (pProperty && propertyCount > 0) {
            for (unsigned int i = 0; i < propertyCount; i++) {
                RNAPropertyAttributeInfo *info = [RNAPropertyAttributeInfo analyseProperty:pProperty[i]
                                                                           WithClass:aClass
                                                                 AndWithCurrentClass:clazz];
                if (![info.oriPropertyName hasSuffix:@"ext_annotation_marker"]) {
                    if (class_conformsToProtocol(clazz, @protocol(NSObject)) &&
                            ([@"hash" isEqualToString:info.oriPropertyName] ||
                                    [@"superclass" isEqualToString:info.oriPropertyName] ||
                                    [@"description" isEqualToString:info.oriPropertyName] ||
                                    [@"debugDescription" isEqualToString:info.oriPropertyName])) {
                        continue;
                    }

                    infoBlock(aClass, clazz, info);
                }
            }
        }
        if (pProperty) {
            free(pProperty);
        }
        clazz = class_getSuperclass(clazz);
    }
}

+ (id)getValue:(id)obj with:(RNAPropertyAttributeInfo *)attributeInfo {
    SEL getter = attributeInfo.getter;
    id retForId = nil;
    char retForChar;
    unsigned char retForUnsignedChar;
    bool retForBool;
    double retForDouble;
    int retForInt;
    float retForFloat;
    long retForLong;
    unsigned long retForUnsignedLong;
    long long retForLongLong;
    unsigned long long retForUnsignedLongLong;
    short retForShort;
    unsigned short retForUnsignedShort;
    unsigned retForUnsigned;
    switch (attributeInfo.type) {
        case RNAIU_CHAR:
            retForChar = ((char (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithChar:retForChar];
        case RNAIU_UNSIGNED_CHAR:
            retForUnsignedChar = ((unsigned char (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithUnsignedChar:retForUnsignedChar];
        case RNAIU_C_BOOL:
            retForBool = ((bool (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithBool:retForBool];
        case RNAIU_DOUBLE:
            retForDouble = ((double (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithDouble:retForDouble];
        case RNAIU_INT:
            retForInt = ((int (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithInt:retForInt];
        case RNAIU_FLOAT:
            retForFloat = ((float (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithFloat:retForFloat];
        case RNAIU_LONG:
            retForLong = ((long (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithLong:retForLong];
        case RNAIU_UNSIGNED_LONG:
            retForUnsignedLong = ((unsigned long (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithUnsignedLong:retForUnsignedLong];
        case RNAIU_LONG_LONG:
            retForLongLong = ((long long (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithLongLong:retForLongLong];
        case RNAIU_UNSIGNED_LONG_LONG:
            retForUnsignedLongLong = ((unsigned long long (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithUnsignedLongLong:retForUnsignedLongLong];
        case RNAIU_SHORT:
            retForShort = ((short (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithShort:retForShort];
        case RNAIU_UNSIGNED_SHORT:
            retForUnsignedShort = ((unsigned short (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithUnsignedShort:retForUnsignedShort];
        case RNAIU_UNSIGNED:
            retForUnsigned = ((unsigned (*)(id, SEL)) objc_msgSend)(obj, getter);
            return [NSNumber numberWithUnsignedInt:retForUnsigned];
        case RNAIU_ID:
            retForId = ((id (*)(id, SEL)) objc_msgSend)(obj, getter);
            return retForId;
        default:
            break;
    }
    return nil;
}

+ (NSArray *)getProtocolsFromClass:(Class)clazz {
    unsigned int propertyCount;
    Protocol *__unsafe_unretained *pProtocol = class_copyProtocolList(clazz, &propertyCount);
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:propertyCount];
    if (pProtocol && propertyCount > 0) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            [result addObject:NSStringFromProtocol(pProtocol[i])];
        }
    }
    if (pProtocol) {
        free(pProtocol);
    }

    return result;
}


@end


@implementation RNAIUConvertDefine

@end

