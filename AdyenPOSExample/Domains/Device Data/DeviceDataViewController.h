//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDevice;

/**
 Displays device data for a device.
 */
@interface DeviceDataViewController : UIViewController

/**
 The device to retrieve and display data for.
 */
@property (nonatomic, strong, readonly) ADYDevice *device;

/**
 Initializes the device data view controller.

 @param device The display to retrieve and display data for.
 @return An initialized device data view controller.
 */
- (instancetype)initWithDevice:(ADYDevice *)device NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
