//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionViewController.h"
#import "TransactionComposeViewController.h"
#import "TransactionStateViewController.h"

#import <AdyenToolkit/AdyenToolkit.h>
#import <libextobjc/EXTScope.h>

#import "UIAlertController+Error.h"
#import "ADYTransactionRequest+Helpers.h"

@interface TransactionViewController () <ADYTransactionProcessorDelegate, TransactionComposeViewControllerDelegate, TransactionStateViewControllerDelegate>

@property (nonatomic, strong) ADYDevice *device;
@property (nonatomic, strong) ADYTransactionRequest *transactionRequest;

@property (nonatomic, strong) UINavigationController *containerViewController;
@property (nonatomic, strong) TransactionStateViewController *stateViewController;

@end

@implementation TransactionViewController

- (instancetype)initWithDevice:(ADYDevice *)device {
    NSParameterAssert(device);
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setDevice:device];
        
        [self addChildViewController:[self containerViewController]];
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *containerView = [[self containerViewController] view];
    [[self view] addSubview:containerView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIView *view = [self view];
    UIView *containerView = [[self containerViewController] view];
    [containerView setFrame:[view bounds]];
}

#pragma mark -
#pragma mark Transaction

- (void)beginTransactionWithAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode transactionType:(ADYTransactionType)transactionType {
    NSString *reference = [ADYTransactionRequest randomReference];
    
    NSError *error = nil;
    ADYTransactionRequest *transactionRequest = [[self device] createTransactionRequestWithReference:reference error:&error];
    if (error) {
        [self finishTransactionWithError:error];
        
        return;
    }
    
    [transactionRequest setAmount:amount];
    [transactionRequest setCurrency:currencyCode];
    [transactionRequest setTransactionType:transactionType];
    [transactionRequest startWithDelegate:self error:&error];
    
    if (error) {
        [self finishTransactionWithError:error];
        
        return;
    }
    
    [self setTransactionRequest:transactionRequest];
    
    [self presentStateViewControllerForTransactionRequest:transactionRequest];
}

- (void)finishTransactionWithError:(NSError *)error {
    if (error) {
        @weakify(self);
        UIAlertController *alertController = [UIAlertController alertControllerWithError:error dismissActionHandler:^(UIAlertAction *action) {
            @strongify(self);
            
            [self finishTransactionWithError:nil];
        }];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    [[self delegate] transactionViewControllerDidFinish:self];
}

#pragma mark -
#pragma mark ADYTransactionProcessorDelegate

- (void)transactionStateChanged:(ADYTenderState)state {
    [[self stateViewController] setState:state];
}

- (void)transactionComplete:(ADYTransactionData *)transaction {
    [self setTransactionRequest:nil];
}

- (void)transactionProvidesAdditionalData:(ADYAdditionalDataRequest *)additionalDataRequest {
    [additionalDataRequest continueWithUpdatedAmount:nil];
}

- (void)transactionRequiresReferral:(ADYReferralRequest *)referralRequest {
    [referralRequest submitReferralWithCode:@""];
}

- (void)transactionRequiresSignature:(ADYSignatureRequest *)signatureRequest {
    // Request the shopper's signature and compare it to the signature on the card.
    
    [signatureRequest submitConfirmedSignature:[UIImage new]];
}

- (void)transactionRequiresPrintedReceipt:(ADYPrintReceiptRequest *)printReceiptRequest {
    // Print receipt.
    
    [printReceiptRequest confirmReceiptPrinted:YES];
}

#pragma mark -
#pragma mark Container View Controller

- (UINavigationController *)containerViewController {
    if (_containerViewController) {
        return _containerViewController;
    }
    
    TransactionComposeViewController *composeViewController = [TransactionComposeViewController newStoryboardInstance];
    [composeViewController setDelegate:self];
    
    UINavigationController *containerViewController = [[UINavigationController alloc] initWithRootViewController:composeViewController];
    _containerViewController = containerViewController;
    
    return containerViewController;
}

#pragma mark -
#pragma mark Compose View Controller

- (void)composeViewControllerDidCancel:(TransactionComposeViewController *)composeViewController {
    [self finishTransactionWithError:nil];
}

- (void)composeViewController:(TransactionComposeViewController *)composeViewController didFinishWithAmount:(NSNumber *)amount currencyCode:(NSString *)currencyCode transactionType:(ADYTransactionType)transactionType {
    [self beginTransactionWithAmount:amount currencyCode:currencyCode transactionType:transactionType];
}

#pragma mark -
#pragma mark State View Controller

- (void)presentStateViewControllerForTransactionRequest:(ADYTransactionRequest *)transactionRequest {
    NSNumber *amount = [transactionRequest amount];
    if ([transactionRequest transactionType] == ADYTransactionTypeRefund) {
        amount = [NSNumber numberWithDouble:[amount doubleValue] * -1.0];
    }
    
    TransactionStateViewController *stateViewController = [TransactionStateViewController newStoryboardInstance];
    [stateViewController setReference:[transactionRequest reference]];
    [stateViewController setAmount:amount];
    [stateViewController setCurrencyCode:[transactionRequest currency]];
    [stateViewController setDelegate:self];
    [self setStateViewController:stateViewController];
    
    [[self containerViewController] setViewControllers:@[stateViewController] animated:NO];
}

- (void)stateViewControllerDidSelectCancel:(TransactionStateViewController *)stateViewController {
    [[self transactionRequest] requestCancel];
}

- (void)stateViewControllerDidSelectDismiss:(TransactionStateViewController *)stateViewController {
    [self finishTransactionWithError:nil];
}

@end
