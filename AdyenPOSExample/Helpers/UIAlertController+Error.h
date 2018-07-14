//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (Error)

/**
 Creates and returns an alert controller used to display an error.
 The alert controller includes a dismiss action.

 @param error The error to display.
 @return An alert controller to display the given error.
 */
+ (instancetype)alertControllerWithError:(NSError *)error;

/**
 Creates and returns an alert controller used to display an error.
 The alert controller includes a dismiss action.
 
 @param error The error to display.
 @param dismissActionHandler The handler to invoke when the dismiss action is selected.
 @return An alert controller to display the given error.
 */
+ (instancetype)alertControllerWithError:(NSError *)error dismissActionHandler:(nullable void (^)(UIAlertAction *))dismissActionHandler;

@end

NS_ASSUME_NONNULL_END
