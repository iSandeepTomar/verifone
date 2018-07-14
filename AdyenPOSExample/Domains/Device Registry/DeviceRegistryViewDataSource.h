//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDeviceRegistry;
@class ADYDevice;

/**
 Provides the data source for the device registry table view.
 */
@interface DeviceRegistryViewDataSource : NSObject <UITableViewDataSource>

/**
 The cell class to register on the table view.
 */
@property (nonatomic, assign, readonly, class) Class cellClass;

/**
 The cell reuse identifier to register the cell class with.
 */
@property (nonatomic, copy, readonly, class) NSString *cellReuseIdentifier;

/**
 The device registry to provide the data source for.
 */
@property (nonatomic, strong, readonly) ADYDeviceRegistry *deviceRegistry;

/**
 Initializes the data source.

 @param deviceRegistry The device registry to provide the data source for.
 @return An initialized device registry.
 */
- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry;

/**
 Returns the device at the given index path.
 Throws an assertion when the index path is invalid.

 @param indexPath The index path to look up the device for.
 @return The device at the given index path.
 */
- (ADYDevice *)deviceAtIndexPath:(NSIndexPath *)indexPath;

/**
 Returns an index path for a device at the given index.

 @param index The index to convert to an index path.
 @return The index path corresponding to the given index.
 */
- (NSIndexPath *)indexPathForDeviceAtIndex:(NSUInteger)index;

/**
 Returns the index paths for the indexes of devices in the device registry.

 @param deviceIndexes The indexes to convert to index paths.
 @return An array of index paths corresponding to the given indexes.
 */
- (NSArray<NSIndexPath *> *)indexPathsForDeviceIndexes:(NSIndexSet *)deviceIndexes;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
