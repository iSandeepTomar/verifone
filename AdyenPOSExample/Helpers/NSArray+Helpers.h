//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (Helpers)

/**
 Creates a new array by mapping all objects using the given block.
 
 @param block The block to invoke for every object in the array.
 @return An array with the objects mapped by the block.
 */
- (NSArray *)arrayByMappingObjectsUsingBlock:(id _Nullable (^)(ObjectType object))block;

@end

NS_ASSUME_NONNULL_END
