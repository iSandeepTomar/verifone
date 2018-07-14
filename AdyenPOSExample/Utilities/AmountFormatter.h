//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Formats a transaction amount into a human-readable string.
 */
@interface AmountFormatter : NSObject

/**
 Formats a transaction amount into a human-readable string.

 @param amount The amount to format, in minor units.
 @param currencyCode The currency code of the amount to format.
 @return The formatted amount, or `nil` if formatting failed.
 */
+ (nullable NSString *)stringFromAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
