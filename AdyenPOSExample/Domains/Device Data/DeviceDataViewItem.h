//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Represents an item in the device data table view section.
 */
@interface DeviceDataViewItem : NSObject

/**
 The key of the item.
 */
@property (nonatomic, copy, readonly) NSString *key;

/**
 The value of the item.
 */
@property (nonatomic, copy, readonly) NSString *value;

/**
 Creates and returns an item.

 @param key The key of the item.
 @param value The value of the item. When `nil`, a default value is provided.
 @return An initialized item with the specified key and value.
 */
+ (instancetype)itemWithKey:(NSString *)key value:(nullable NSString *)value;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
