//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "ProgressViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ADYDevice;

@protocol DeviceBoardingViewControllerDelegate;

/**
 Performs the boarding process for a device and displays its progress.
 */
@interface DeviceBoardingViewController : ProgressViewController

/**
 The device that is being boarded.
 */
@property (nonatomic, strong, readonly) ADYDevice *device;

/**
 The delegate of the device boarding view controller.
 */
@property (nonatomic, weak, readwrite, nullable) id<DeviceBoardingViewControllerDelegate> delegate;

/**
 Initializes the device boarding view controller.

 @param device The device to board.
 @return An initialized device boarding view controller.
 */
- (instancetype)initWithDevice:(ADYDevice *)device NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from a `DeviceBoardingViewController`.
 */
@protocol DeviceBoardingViewControllerDelegate <NSObject>

/**
 Invoked when the device boarding view controller has finished boarding the device.

 @param deviceBoardingViewController The view controller that finished boarding the device.
 @param error An error that occurred, or nil if the device was boarded successfully.
 */
- (void)deviceBoardingViewController:(DeviceBoardingViewController *)deviceBoardingViewController didFinishWithError:(nullable NSError *)error;

@end

NS_ASSUME_NONNULL_END
