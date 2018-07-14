//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionsViewDataSource.h"
#import "TransactionsViewCell.h"

#import <AdyenToolkit/ADYTransactionData.h>

#import "AmountFormatter.h"

@implementation TransactionsViewDataSource

#pragma mark -
#pragma mark Cell

+ (Class)cellClass {
    return [TransactionsViewCell class];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self cellClass]);
}

#pragma mark -
#pragma mark Transactions

- (ADYTransactionData *)transactionAtIndexPath:(NSIndexPath *)indexPath {
    return [[self transactions] objectAtIndex:[indexPath row]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self transactions] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[TransactionsViewDataSource cellReuseIdentifier]
                                                                 forIndexPath:indexPath];
    
    ADYTransactionData *transaction = [self transactionAtIndexPath:indexPath];
    [cell setReference:[transaction merchantReference]];
    [cell setState:[[transaction finalStateString] localizedCapitalizedString]];
    [cell setAmount:[self formattedAmountForTransaction:transaction]];
    
    return cell;
}

- (NSString *)formattedAmountForTransaction:(ADYTransactionData *)transaction {
    NSNumber *amount = [transaction finalAmountValue];
    if ([transaction transactionType] == ADYTransactionTypeRefund) {
        amount = [NSNumber numberWithDouble:[amount doubleValue] * -1.0];
    }
    
    return [AmountFormatter stringFromAmount:amount currencyCode:[transaction finalAmountCurrency]];
}

@end
