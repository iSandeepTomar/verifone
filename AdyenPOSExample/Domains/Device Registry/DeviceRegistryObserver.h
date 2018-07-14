//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDeviceRegistry;

@protocol DeviceRegistryObserverDelegate;

/**
 Observes a device registry for new devices and device state changes.
 */
@interface DeviceRegistryObserver : NSObject

/**
 The device registry to observe.
 */
@property (nonatomic, strong, readonly) ADYDeviceRegistry *deviceRegistry;

/**
 The delegate of the device registry observer.
 */
@property (nonatomic, weak, readwrite, nullable) id<DeviceRegistryObserverDelegate> delegate;

/**
 Initializes the device registry observer.

 @param deviceRegistry The device registry to observe.
 @return An initialized device registry observer.
 */
- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be informed of changes in the device registry.
 */
@protocol DeviceRegistryObserverDelegate <NSObject>

/**
 Invoked when the devices in the device registry are reloaded.

 @param deviceRegistryObserver The device registry observer that detected the reload.
 */
- (void)deviceRegistryObserverDeviceRegistryDidReloadDevices:(DeviceRegistryObserver *)deviceRegistryObserver;

/**
 Invoked when devices are inserted in the device registry.

 @param deviceRegistryObserver The device registry observer that detected the insertion.
 @param indexes The indexes of the devices that have been inserted.
 */
- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceRegistryDidInsertDevicesAtIndexes:(NSIndexSet *)indexes;

/**
 Invoked when devices are removed from the device registry.

 @param deviceRegistryObserver The device registry observer that detected the removal.
 @param indexes The indexes of the devices that have been removed.
 */
- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceRegistryDidRemoveDevicesAtIndexes:(NSIndexSet *)indexes;

/**
 Invoked when the status of a device in the device registry changes.

 @param deviceRegistryObserver The device registry observer that detected the status change.
 @param index The index of the device whose status changed.
 */
- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceStatusDidChangeForDeviceAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
