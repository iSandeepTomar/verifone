//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>
#import <AdyenToolkit/ADYConstants.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TransactionStateViewControllerDelegate;

/**
 Displays the state of an ongoing transaction.
 */
@interface TransactionStateViewController : UITableViewController

/**
 The reference of the transaction.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *reference;

/**
 The amount of the transaction.
 */
@property (nonatomic, strong, readwrite, nullable) NSNumber *amount;

/**
 The currency code of the transaction's amount.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *currencyCode;

/**
 The current state of the transaction.
 */
@property (nonatomic, assign, readwrite) ADYTenderState state;

/**
 The delegate of the state view controller.
 */
@property (nonatomic, weak, readwrite, nullable) id<TransactionStateViewControllerDelegate> delegate;

+ (instancetype)newStoryboardInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from a `TransactionStateViewController`.
 */
@protocol TransactionStateViewControllerDelegate <NSObject>

/**
 Invoked when the user opts to cancel the transaction.

 @param stateViewController The state view controller in which the cancel button was selected.
 */
- (void)stateViewControllerDidSelectCancel:(TransactionStateViewController *)stateViewController;

/**
 Invoked when the user opts to dismiss the transaction.
 
 @param stateViewController The state view controller in which the dismiss button was selected.
 */
- (void)stateViewControllerDidSelectDismiss:(TransactionStateViewController *)stateViewController;

@end

NS_ASSUME_NONNULL_END
