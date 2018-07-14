//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "ADYTransactionRequest+Helpers.h"

@implementation ADYTransactionRequest (Helpers)

+ (NSString *)randomReference {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    char data[5];
    for (int i = 0; i < 5; data[i++] = (char)('A' + (arc4random_uniform(26))));
    
    NSMutableString *reference = [[NSMutableString alloc] initWithBytes:data length:sizeof(data) encoding:NSUTF8StringEncoding];
    [reference appendString:@" "];
    [reference appendString:[dateFormatter stringFromDate:[NSDate date]]];
    
    return [reference copy];
}

@end
