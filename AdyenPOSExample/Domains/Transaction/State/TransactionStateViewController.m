//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionStateViewController.h"
#import "AmountFormatter.h"

@interface TransactionStateViewController ()

@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *stateLabel;
@property (nonatomic, weak) IBOutlet UITableViewCell *stateCell;

@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, assign) BOOL showsDismissButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) BOOL showsActivityIndicatorView;

@property (nonatomic, assign) BOOL showsCheckmark;

@end

@implementation TransactionStateViewController

+ (instancetype)newStoryboardInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    TransactionStateViewController *viewController = [storyboard instantiateInitialViewController];
    
    return viewController;
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self resetAmountLabel];
}

#pragma mark -
#pragma mark Navigation Item

- (void)setShowsCancelButton:(BOOL)showsCancelButton {
    if (showsCancelButton == _showsCancelButton) {
        return;
    }
    
    _showsCancelButton = showsCancelButton;
    
    UINavigationItem *navigationItem = [self navigationItem];
    BOOL animated = [self isViewLoaded];
    
    if (showsCancelButton) {
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(didSelectCancelButton:)];
        [navigationItem setLeftBarButtonItem:cancelButtonItem animated:animated];
    } else {
        [navigationItem setLeftBarButtonItem:nil animated:animated];
    }
}

- (void)didSelectCancelButton:(id)sender {
    [[self delegate] stateViewControllerDidSelectCancel:self];
}

- (void)setShowsDismissButton:(BOOL)showsDismissButton {
    if (showsDismissButton == _showsDismissButton) {
        return;
    }
    
    _showsDismissButton = showsDismissButton;
    
    UINavigationItem *navigationItem = [self navigationItem];
    BOOL animated = [self isViewLoaded];
    
    if (showsDismissButton) {
        UIBarButtonItem *dismissButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(didSelectDismissButton:)];
        [navigationItem setRightBarButtonItem:dismissButtonItem animated:animated];
    } else {
        [navigationItem setRightBarButtonItem:nil animated:animated];
    }
}

- (void)didSelectDismissButton:(id)sender {
    [[self delegate] stateViewControllerDidSelectDismiss:self];
}

#pragma mark -
#pragma mark Activity Indicator View

- (UIActivityIndicatorView *)activityIndicatorView {
    if (_activityIndicatorView) {
        return _activityIndicatorView;
    }
    
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView sizeToFit];
    _activityIndicatorView = activityIndicatorView;
    
    return activityIndicatorView;
}

- (void)setShowsActivityIndicatorView:(BOOL)showsActivityIndicatorView {
    if (showsActivityIndicatorView == _showsActivityIndicatorView) {
        return;
    }
    
    _showsActivityIndicatorView = showsActivityIndicatorView;
    
    UIActivityIndicatorView *activityIndicatorView = [self activityIndicatorView];
    UITableViewCell *stateCell = [self stateCell];
    
    if (showsActivityIndicatorView) {
        [stateCell setAccessoryView:activityIndicatorView];
        [activityIndicatorView startAnimating];
    } else {
        [stateCell setAccessoryView:nil];
        [activityIndicatorView stopAnimating];
    }
}

#pragma mark -
#pragma mark Checkmark

- (void)setShowsCheckmark:(BOOL)showsCheckmark {
    if (showsCheckmark == _showsCheckmark) {
        return;
    }
    
    _showsCheckmark = showsCheckmark;
    
    UITableViewCell *stateCell = [self stateCell];
    if (showsCheckmark) {
        [stateCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [stateCell setAccessoryType:UITableViewCellAccessoryNone];
    }
}

#pragma mark -
#pragma mark Reference

- (void)setReference:(NSString *)reference {
    _reference = [reference copy];
    
    [self setTitle:reference];
}

#pragma mark -
#pragma mark Amount

- (void)setAmount:(NSNumber *)amount {
    _amount = amount;
    
    [self resetAmountLabel];
}

- (void)setCurrencyCode:(NSString *)currencyCode {
    _currencyCode = [currencyCode copy];
    
    [self resetAmountLabel];
}

- (void)resetAmountLabel {
    if (![self isViewLoaded]) {
        return;
    }
    
    NSNumber *amount = [self amount] ?: @0;
    NSString *currencyCode = [self currencyCode] ?: [[NSLocale currentLocale] currencyCode];
    NSString *formattedAmount = [AmountFormatter stringFromAmount:amount currencyCode:currencyCode];
    [[self amountLabel] setText:formattedAmount];
}

#pragma mark -
#pragma mark State

- (void)setState:(ADYTenderState)state {
    _state = state;
    
    NSString *text = nil;
    BOOL isFinished = NO;
    BOOL isSuccessful = NO;
    
    switch (state) {
        case ADYTenderStateInitial:
            text = @"Initializing transaction";
            
            break;
        case ADYTenderStateCreated:
            text = @"Transaction started";
            
            break;
        case ADYTenderStateProcessing:
            text = @"Transaction started";
            
            break;
        case ADYTenderStateAskSignature:
            text = @"Signature requested";
            
            break;
        case ADYTenderStateCheckSignature:
            text = @"Verifying signature";
            
            break;
        case ADYTenderStateSignatureChecked:
            text = @"Signature verified";
            
            break;
        case ADYTenderStateWaitingForPin:
            text = @"Waiting for PIN";
            
            break;
        case ADYTenderStatePinDigitEntered:
            text = @"Waiting for PIN";
            
            break;
        case ADYTenderStatePinEntered:
            text = @"PIN entered";
            
            break;
        case ADYTenderStateAskGratuity:
            text = @"Gratuity requested";
            
            break;
        case ADYTenderStateGratuityEntered:
            text = @"Gratuity entered";
            
            break;
        case ADYTenderStateAskSwipeCard:
            text = @"Card requested";
            
            break;
        case ADYTenderStateCardSwiped:
            text = @"Card swiped";
            
            break;
        case ADYTenderStateAskInsertCard:
            text = @"Card requested";
            
            break;
        case ADYTenderStateCardInserted:
            text = @"Card inserted";
            
            break;
        case ADYTenderStateCardRemoved:
            text = @"Card removed";
            
            break;
        case ADYTenderStateAskPresentCard:
            text = @"Card requested";
            
            break;
        case ADYTenderStateCardPresented:
            text = @"Card presented";
            
            break;
        case ADYTenderStatePrintReceipt:
            text = @"Printing receipt";
            
            break;
        case ADYTenderStateReceiptPrinted:
            text = @"Receipt printed";
            
            break;
        case ADYTenderStateWaitingEndStateConfirmation:
            text = @"Waiting for confirmation...";
            
            break;
        case ADYTenderStateApproved:
            text = @"Transaction approved";
            isFinished = YES;
            isSuccessful = YES;
            
            break;
        case ADYTenderStateDeclined:
            text = @"Transaction declined";
            isFinished = YES;
            
            break;
        case ADYTenderStateCancelled:
            text = @"Transaction cancelled";
            isFinished = YES;
            
            break;
        case ADYTenderStateError:
            text = @"Transaction failed";
            isFinished = YES;
            
            break;
        default:
            break;
    }
    
    [[self stateLabel] setText:text];
    
    [self setShowsCancelButton:!isFinished];
    [self setShowsDismissButton:isFinished];
    [self setShowsActivityIndicatorView:!isFinished];
    [self setShowsCheckmark:isFinished && isSuccessful];
}

@end
