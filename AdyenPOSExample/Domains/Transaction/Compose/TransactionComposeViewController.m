//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionComposeViewController.h"
#import "AmountField.h"

@interface TransactionComposeViewController () <AmountFieldDelegate>

@property (nonatomic, weak) IBOutlet AmountField *amountField;

@property (nonatomic, weak) IBOutlet UISegmentedControl *transactionTypeControl;
@property (nonatomic, readonly) ADYTransactionType transactionType;

@end

@implementation TransactionComposeViewController

+ (instancetype)newStoryboardInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    TransactionComposeViewController *viewController = [storyboard instantiateInitialViewController];
    
    return viewController;
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"New Transaction"];
    
    UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didSelectCancelButton:)];
    [[self navigationItem] setLeftBarButtonItem:cancelButtonItem];
    
    UIBarButtonItem *startButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStyleDone target:self action:@selector(didSelectStartButton:)];
    [startButtonItem setEnabled:NO];
    [[self navigationItem] setRightBarButtonItem:startButtonItem];
    
    AmountField *amountField = [self amountField];
    [amountField setCurrencyCode:@"EUR"];
    [amountField setAmountFieldDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self amountField] becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self amountField] resignFirstResponder];
}

#pragma mark -
#pragma mark Navigation Item

- (void)didSelectCancelButton:(id)sender {
    [[self delegate] composeViewControllerDidCancel:self];
}

- (void)didSelectStartButton:(id)sender {
    AmountField *amountField = [self amountField];
    [[self delegate] composeViewController:self didFinishWithAmount:[amountField amount] currencyCode:[amountField currencyCode] transactionType:[self transactionType]];
}

#pragma mark -
#pragma mark Amount Field

- (void)amountField:(AmountField *)amountField didEnterAmount:(NSNumber *)amount {
    UIBarButtonItem *startButtonItem = [[self navigationItem] rightBarButtonItem];
    [startButtonItem setEnabled:![amount isEqualToNumber:@0]];
}

#pragma mark -
#pragma mark Transaction Type

- (ADYTransactionType)transactionType {
    NSInteger index = [[self transactionTypeControl] selectedSegmentIndex];
    if (index == 0) {
        return ADYTransactionTypeGoodsServices;
    } else if (index == 1) {
        return ADYTransactionTypeRefund;
    }
    
    return ADYTransactionTypeGoodsServices;
}

@end
