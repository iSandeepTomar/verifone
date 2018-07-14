//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "AmountFormatter.h"

@implementation AmountFormatter

+ (NSString *)stringFromAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode {
    NSParameterAssert(amount);
    NSParameterAssert(currencyCode);
    
    NSNumber *dividedAmount = [NSNumber numberWithDouble:[amount doubleValue] / 100.0];
    
    NSNumberFormatter *numberFormatter = [self numberFormatter];
    [numberFormatter setCurrencyCode:currencyCode];
    
    return [numberFormatter stringFromNumber:dividedAmount];
}

+ (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *numberFormatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        numberFormatter = [NSNumberFormatter new];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    });
    
    return numberFormatter;
}

@end
