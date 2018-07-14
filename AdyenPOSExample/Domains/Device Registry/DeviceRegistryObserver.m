//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceRegistryObserver.h"

#import <AdyenToolkit/AdyenToolkit.h>

static void *DeviceRegistryObserverContext = &DeviceRegistryObserverContext;
static NSString *DeviceRegistryObserverDevicesKeyPath = @"deviceRegistry.devices";
static NSString *DeviceRegistryObserverDeviceStatusKeyPath = @"status";

@interface DeviceRegistryObserver ()

@property (nonatomic, strong, readwrite) ADYDeviceRegistry *deviceRegistry;

@property (nonatomic, strong) NSMutableArray *observedDevices;

@end

@implementation DeviceRegistryObserver

- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry {
    NSParameterAssert(deviceRegistry);
    
    if (self = [super init]) {
        [self setDeviceRegistry:deviceRegistry];
        
        [self addObserver:self
               forKeyPath:DeviceRegistryObserverDevicesKeyPath
                  options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                  context:DeviceRegistryObserverContext];
    }
    
    return self;
}

- (void)dealloc {
    [self removeObserver:self
              forKeyPath:DeviceRegistryObserverDevicesKeyPath
                 context:DeviceRegistryObserverContext];
    
    [self removeObserversForAllDevices];
}

#pragma mark -
#pragma mark Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != DeviceRegistryObserverContext) {
        return;
    }
    
    // Since the passed change dictionary is mutable, copy it to avoid changes when moving to the main thread.
    NSDictionary *copiedChange = [change copy];
    
    if ([keyPath isEqualToString:DeviceRegistryObserverDevicesKeyPath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleDevicesChange:copiedChange];
        });
    } else if ([keyPath isEqualToString:DeviceRegistryObserverDeviceStatusKeyPath]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self handleDeviceStatusChange:copiedChange object:object];
        });
    }
}

#pragma mark -
#pragma mark Device Registry Observation

- (void)handleDevicesChange:(NSDictionary *)change {
    NSKeyValueChange kind = [change[NSKeyValueChangeKindKey] unsignedIntegerValue];
    NSIndexSet *indexes = change[NSKeyValueChangeIndexesKey];
    
    switch (kind) {
        case NSKeyValueChangeSetting: {
            NSArray *devices = change[NSKeyValueChangeNewKey];
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [devices count])];
            [self addObserversForDevicesAtIndexes:indexes];
            
            [[self delegate] deviceRegistryObserverDeviceRegistryDidReloadDevices:self];
            
            break;
        }
        case NSKeyValueChangeInsertion: {
            [self addObserversForDevicesAtIndexes:indexes];
            
            [[self delegate] deviceRegistryObserver:self deviceRegistryDidInsertDevicesAtIndexes:indexes];
            
            break;
        }
        case NSKeyValueChangeRemoval: {
            [self removeObserversForDevicesAtIndexes:indexes];
            
            [[self delegate] deviceRegistryObserver:self deviceRegistryDidRemoveDevicesAtIndexes:indexes];
            
            break;
        }
        case NSKeyValueChangeReplacement: {
            break;
        }
    }
}

#pragma mark -
#pragma mark Device Observation

- (NSMutableArray *)observedDevices {
    if (_observedDevices) {
        return _observedDevices;
    }
    
    NSMutableArray *observedDevices = [[NSMutableArray alloc] init];
    _observedDevices = observedDevices;
    
    return observedDevices;
}

- (void)addObserversForDevicesAtIndexes:(NSIndexSet *)indexes {
    NSArray *devices = [[[self deviceRegistry] devices] objectsAtIndexes:indexes];
    
    for (ADYDevice *device in devices) {
        [device addObserver:self forKeyPath:DeviceRegistryObserverDeviceStatusKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:DeviceRegistryObserverContext];
    }
    
    [[self observedDevices] addObjectsFromArray:devices];
}

- (void)removeObserversForDevicesAtIndexes:(NSIndexSet *)indexes {
    NSArray *devices = [[self observedDevices] objectsAtIndexes:indexes];
    
    for (ADYDevice *device in devices) {
        [device removeObserver:self forKeyPath:DeviceRegistryObserverDeviceStatusKeyPath context:DeviceRegistryObserverContext];
    }
    
    [[self observedDevices] removeObjectsAtIndexes:indexes];
}

- (void)removeObserversForAllDevices {
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [[self observedDevices] count])];
    [self removeObserversForDevicesAtIndexes:indexes];
}

- (void)handleDeviceStatusChange:(NSDictionary *)change object:(id)object {
    NSNumber *newValue = change[NSKeyValueChangeNewKey];
    NSNumber *oldValue = change[NSKeyValueChangeOldKey];
    NSUInteger index = [[[self deviceRegistry] devices] indexOfObject:object];
    
    if ([newValue isEqualToValue:oldValue] || index == NSNotFound) {
        return;
    }
    
    [[self delegate] deviceRegistryObserver:self deviceStatusDidChangeForDeviceAtIndex:index];
}

@end
