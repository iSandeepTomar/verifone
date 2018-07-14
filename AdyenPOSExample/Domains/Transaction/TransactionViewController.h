//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYDevice;

@protocol TransactionViewControllerDelegate;

/**
 Handles the process of creating and performing a transaction, including user input.
 */
@interface TransactionViewController : UIViewController

/**
 The device to perform the transaction with.
 */
@property (nonatomic, strong, readonly) ADYDevice *device;

/**
 The delegate of the transaction view controller.
 */
@property (nonatomic, weak, readwrite, nullable) id<TransactionViewControllerDelegate> delegate;

/**
 Initializes the transaction view controller.

 @param device The device to perform the transaction with.
 @return An initialized transaction view controller.
 */
- (instancetype)initWithDevice:(ADYDevice *)device NS_DESIGNATED_INITIALIZER;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from a `TransactionViewController`.
 */
@protocol TransactionViewControllerDelegate <NSObject>

/**
 Invoked when the transaction view controller finished the transaction.

 @param transactionViewController The transaction view controller that finished the transaction.
 */
- (void)transactionViewControllerDidFinish:(TransactionViewController *)transactionViewController;

@end

NS_ASSUME_NONNULL_END
