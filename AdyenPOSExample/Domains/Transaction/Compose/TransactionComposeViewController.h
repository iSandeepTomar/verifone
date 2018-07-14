//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>
#import <AdyenToolkit/ADYConstants.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TransactionComposeViewControllerDelegate;

/**
 Provides an interface to enter the required information to start a transaction.
 */
@interface TransactionComposeViewController : UITableViewController

/**
 The delegate of the compose view controller.
 */
@property (nonatomic, weak, readwrite, nullable) id<TransactionComposeViewControllerDelegate> delegate;

+ (instancetype)newStoryboardInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from a `TransactionComposeViewController`.
 */
@protocol TransactionComposeViewControllerDelegate <NSObject>

/**
 Invoked when the user has cancelled composing a transaction.

 @param composeViewController The compose view controller that was cancelled.
 */
- (void)composeViewControllerDidCancel:(TransactionComposeViewController *)composeViewController;

/**
 Invoked when the user has finished composing a transaction.

 @param composeViewController The compose view controller in which the transaction was composed.
 @param amount The amount that was filled in.
 @param currencyCode The code of the currency in which the amount is specified.
 @param transactionType The type of transaction.
 */
- (void)composeViewController:(TransactionComposeViewController *)composeViewController didFinishWithAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode transactionType:(ADYTransactionType)transactionType;

@end

NS_ASSUME_NONNULL_END
