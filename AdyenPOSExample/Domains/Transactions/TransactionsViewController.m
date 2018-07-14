//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionsViewController.h"
#import "TransactionsViewDataSource.h"

#import <AdyenToolkit/AdyenToolkit.h>

@interface TransactionsViewController () <UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TransactionsViewDataSource *tableViewDataSource;

@end

@implementation TransactionsViewController

- (instancetype)init {
    if (self = [super init]) {
        [self setTitle:@"Transactions"];
        
        [[self tabBarItem] setImage:[UIImage imageNamed:@"TransactionsTabBarItem"]];
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)loadView {
    [self setView:[self tableView]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadTransactions];
}

#pragma mark -
#pragma mark Table View

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    
    UITableView *tableView = [[UITableView alloc] init];
    [tableView setRowHeight:UITableViewAutomaticDimension];
    [tableView setEstimatedRowHeight:66.0f];
    [tableView setDataSource:[self tableViewDataSource]];
    [tableView setDelegate:self];
    
    [tableView registerClass:[TransactionsViewDataSource cellClass]
      forCellReuseIdentifier:[TransactionsViewDataSource cellReuseIdentifier]];
    
    _tableView = tableView;
    
    return tableView;
}

- (TransactionsViewDataSource *)tableViewDataSource {
    if (_tableViewDataSource) {
        return _tableViewDataSource;
    }
    
    TransactionsViewDataSource *tableViewDataSource = [[TransactionsViewDataSource alloc] init];
    _tableViewDataSource = tableViewDataSource;
    
    return tableViewDataSource;
}

#pragma mark -
#pragma mark Transactions

- (void)reloadTransactions {
    NSArray *transactions = [[Adyen sharedInstance] getTransactions];
    [[self tableViewDataSource] setTransactions:transactions];
    [[self tableView] reloadData];
}

@end
