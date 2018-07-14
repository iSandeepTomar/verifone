//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class DeviceDataViewItem;

/**
 Represents a section in the device data table view.
 */
@interface DeviceDataViewSection : NSObject

/**
 The title of the section.
 */
@property (nonatomic, copy, readonly) NSString *title;

/**
 The items in the section.
 */
@property (nonatomic, copy, readonly) NSArray<DeviceDataViewItem *> *items;

/**
 Creates and returns a section.

 @param title The title of the section.
 @param items The items in the section.
 @return An initialized section with the specified title and items.
 */
+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray<DeviceDataViewItem *> *)items;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
