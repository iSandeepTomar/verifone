//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AmountFieldDelegate;

/**
 Provides a field designed to enter a transaction amount.
 */
@interface AmountField : UITextField

/**
 The delegate of the amount field.
 */
@property (nonatomic, weak, readwrite, nullable) id<AmountFieldDelegate> amountFieldDelegate;

/**
 The currently filled in amount, in minor units.
 */
@property (nonatomic, strong, readwrite) NSNumber *amount;

/**
 The currency code to format the amount with. Defaults to the current locale's currency code.
 */
@property (nonatomic, copy, readwrite) NSString *currencyCode;

@end

/**
 Protocol that defines methods a delegate can implement to be notified of events from an `AmountField`.
 */
@protocol AmountFieldDelegate <NSObject>

/**
 Invoked when the user has entered a new amount.

 @param amountField The amount field in which the amount was entered.
 @param amount The amount that was entered.
 */
- (void)amountField:(AmountField *)amountField didEnterAmount:(NSNumber *)amount;

@end

NS_ASSUME_NONNULL_END
