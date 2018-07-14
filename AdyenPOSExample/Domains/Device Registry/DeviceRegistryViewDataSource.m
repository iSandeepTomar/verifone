//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceRegistryViewDataSource.h"
#import "DeviceRegistryViewCell.h"

#import <AdyenToolkit/ADYDeviceRegistry.h>
#import <AdyenToolkit/ADYDevice.h>

#import "NSArray+Helpers.h"
#import "NSStringFromADYDeviceStatus.h"

@interface DeviceRegistryViewDataSource ()

@property (nonatomic, strong, readwrite) ADYDeviceRegistry *deviceRegistry;

@end

@implementation DeviceRegistryViewDataSource

- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry {
    NSParameterAssert(deviceRegistry);
    
    if (self = [super init]) {
        [self setDeviceRegistry:deviceRegistry];
    }
    
    return self;
}

#pragma mark -
#pragma mark Cell

+ (Class)cellClass {
    return [DeviceRegistryViewCell class];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self cellClass]);
}

#pragma mark -
#pragma mark Index Paths

- (ADYDevice *)deviceAtIndexPath:(NSIndexPath *)indexPath {
    return [[[self deviceRegistry] devices] objectAtIndex:[indexPath row]];
}

- (NSIndexPath *)indexPathForDeviceAtIndex:(NSUInteger)index {
    return [NSIndexPath indexPathForRow:index inSection:0];
}

- (NSArray<NSIndexPath *> *)indexPathsForDeviceIndexes:(NSIndexSet *)deviceIndexes {
    NSMutableArray *indexPaths = [NSMutableArray array];
    
    [deviceIndexes enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
        [indexPaths addObject:[self indexPathForDeviceAtIndex:index]];
    }];
    
    return [indexPaths copy];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self deviceRegistry] devices] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceRegistryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeviceRegistryViewDataSource cellReuseIdentifier]
                                                                   forIndexPath:indexPath];
    
    ADYDevice *device = [self deviceAtIndexPath:indexPath];
    [cell setName:[device name]];
    [cell setStatus:NSStringFromADYDeviceStatus([device status])];
    
    if ([device connectionType] == ADYDeviceConnectionTypeMFI) {
        [cell setConnectionIcon:DeviceRegistryViewCellConnectionIconMFI];
    } else if ([device connectionType] == ADYDeviceConnectionTypeWifi) {
        [cell setConnectionIcon:DeviceRegistryViewCellConnectionIconWiFi];
    }
    
    if ([device status] == ADYDeviceStatusInitialized || [device status] == ADYDeviceStatusNotBoarded) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        [cell setShowsDetailButton:YES];
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setShowsDetailButton:NO];
    }
    
    return cell;
}

@end
