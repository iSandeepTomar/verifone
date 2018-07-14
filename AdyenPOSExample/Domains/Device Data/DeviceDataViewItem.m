//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceDataViewItem.h"

@interface DeviceDataViewItem ()

@property (nonatomic, copy, readwrite) NSString *key;
@property (nonatomic, copy, readwrite) NSString *value;

@end

@implementation DeviceDataViewItem

+ (instancetype)itemWithKey:(NSString *)key value:(NSString *)value {
    NSParameterAssert(key);
    
    DeviceDataViewItem *item = [super new];
    [item setKey:key];
    [item setValue:value ?: @"N/A"];
    
    return item;
}

@end
