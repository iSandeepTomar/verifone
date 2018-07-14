//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ADYTransactionData;

/**
 Provides the data source for the transactions table view.
 */
@interface TransactionsViewDataSource : NSObject <UITableViewDataSource>

/**
 The cell class to register on the table view.
 */
@property (nonatomic, assign, readonly, class) Class cellClass;

/**
 The cell reuse identifier to register the cell class with.
 */
@property (nonatomic, copy, readonly, class) NSString *cellReuseIdentifier;

/**
 The transactions to provide in the data source.
 */
@property (nonatomic, copy, readwrite, nullable) NSArray<ADYTransactionData *> *transactions;

@end

NS_ASSUME_NONNULL_END
