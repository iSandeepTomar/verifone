//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum specifying available connection icons.
 */
typedef NS_ENUM(NSUInteger, DeviceRegistryViewCellConnectionIcon) {
    
    /// Indicates an MFI connection.
    DeviceRegistryViewCellConnectionIconMFI,
    
    /// Indicates a WiFi connection.
    DeviceRegistryViewCellConnectionIconWiFi
    
};

/**
 A table view cell that displays basic device information.
 */
@interface DeviceRegistryViewCell : UITableViewCell

/**
 The name of the device.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *name;

/**
 The status of the device.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *status;

/**
 The connection icon to show for the device.
 */
@property (nonatomic, assign, readwrite) DeviceRegistryViewCellConnectionIcon connectionIcon;

/**
 Whether or not the detail button should be shown.
 */
@property (nonatomic, assign, readwrite) BOOL showsDetailButton;

@end

NS_ASSUME_NONNULL_END
