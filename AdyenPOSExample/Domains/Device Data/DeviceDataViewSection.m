//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceDataViewSection.h"

@interface DeviceDataViewSection ()

@property (nonatomic, copy, readwrite) NSString *title;
@property (nonatomic, copy, readwrite) NSArray *items;

@end

@implementation DeviceDataViewSection

+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray<DeviceDataViewItem *> *)items {
    NSParameterAssert(title);
    NSParameterAssert(items);
    
    DeviceDataViewSection *section = [super new];
    [section setTitle:title];
    [section setItems:items];
    
    return section;
}

@end
