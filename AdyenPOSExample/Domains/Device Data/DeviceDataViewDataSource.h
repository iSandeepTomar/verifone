//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDevice;
@class ADYDeviceData;

/**
 Provides the data source for the device data table view.
 */
@interface DeviceDataViewDataSource : NSObject <UITableViewDataSource>

/**
 The cell class to register on the table view.
 */
@property (nonatomic, assign, readonly, class) Class cellClass;

/**
 The cell reuse identifier to register the cell class with.
 */
@property (nonatomic, copy, readonly, class) NSString *cellReuseIdentifier;

/**
 The device for which the data source is provided.
 */
@property (nonatomic, strong, readonly) ADYDevice *device;

/**
 The device data to provide in the data source.
 */
@property (nonatomic, strong, readwrite, nullable) ADYDeviceData *deviceData;

/**
 Initializes the data source.

 @param device The device for which the data source is provided.
 @return An initialized data source.
 */
- (instancetype)initWithDevice:(ADYDevice *)device NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
