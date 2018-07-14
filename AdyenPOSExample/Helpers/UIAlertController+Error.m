//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "UIAlertController+Error.h"

@implementation UIAlertController (Error)

+ (instancetype)alertControllerWithError:(NSError *)error {
    return [self alertControllerWithError:error dismissActionHandler:nil];
}

+ (instancetype)alertControllerWithError:(NSError *)error dismissActionHandler:(void (^)(UIAlertAction *))dismissActionHandler {
    NSParameterAssert(error);
    
    NSError *underlyingError = [error userInfo][NSUnderlyingErrorKey];
    
    NSString *title = @"Error";
    NSString *message = [underlyingError localizedDescription] ?: [error localizedDescription] ?: @"An unknown error occurred.";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:dismissActionHandler]];
    
    return alertController;
}

@end
