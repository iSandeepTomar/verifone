//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A table view cell that displays a key-value pair of device data.
 */
@interface DeviceDataViewCell : UITableViewCell

/**
 The key to display.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *key;

/**
 The value to display.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *value;

@end

NS_ASSUME_NONNULL_END
