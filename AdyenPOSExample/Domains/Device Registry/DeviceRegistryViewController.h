//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDeviceRegistry;
@class ADYDevice;

@protocol DeviceRegistryViewControllerDelegate;

/**
 Displays a list of connected devices, and provides functionality to add a new device and remove existing devices.
 */
@interface DeviceRegistryViewController : UIViewController

/**
 The device registry that is being displayed.
 */
@property (nonatomic, strong, readonly) ADYDeviceRegistry *deviceRegistry;

/**
 The delegate of the device registry view controller.
 */
@property (nonatomic, weak, readwrite, nullable) id<DeviceRegistryViewControllerDelegate> delegate;

/**
 Initializes the device registry view controller.

 @param deviceRegistry The device registry to use for listing and adding devices.
 @return An initialized device registry view controller.
 */
- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from a `DeviceRegistryViewController`.
 */
@protocol DeviceRegistryViewControllerDelegate <NSObject>

/**
 Invoked when a device is selected in the device registry view controller.

 @param deviceRegistryViewController The view controller in which the device has been selected.
 @param device The device that has been selected.
 */
- (void)deviceRegistryViewController:(DeviceRegistryViewController *)deviceRegistryViewController didSelectDevice:(ADYDevice *)device;

@end

NS_ASSUME_NONNULL_END
