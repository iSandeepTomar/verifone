//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A table view cell that displays basic transaction information.
 */
@interface TransactionsViewCell : UITableViewCell

/**
 The reference of the transaction.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *reference;

/**
 The state of the transaction.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *state;

/**
 The formatted amount of the transaction.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *amount;

@end

NS_ASSUME_NONNULL_END
