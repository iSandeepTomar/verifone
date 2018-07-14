//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "NSArray+Helpers.h"

@implementation NSArray (Helpers)

- (NSArray *)arrayByMappingObjectsUsingBlock:(id (^)(id))block {
    NSMutableArray *mappedArray = [NSMutableArray new];
    
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        id mappedObject = block(object);
        if (!mappedObject) {
            return;
        }
        
        [mappedArray addObject:mappedObject];
    }];
    
    return [mappedArray copy];
}

@end
