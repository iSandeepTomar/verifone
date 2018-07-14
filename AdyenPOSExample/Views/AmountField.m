//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "AmountField.h"
#import "AmountFormatter.h"

@interface AmountField () <UITextFieldDelegate>

@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@end

@implementation AmountField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self configure];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    [self setAdjustsFontSizeToFitWidth:NO];
    [self setAutocorrectionType:UITextAutocorrectionTypeNo];
    [self setKeyboardType:UIKeyboardTypeNumberPad];
    [self setDelegate:self];
    
    _amount = @0;
    _currencyCode = [[NSLocale currentLocale] currencyCode];
    [self reloadText];
    [self reloadPlaceholder];
}

#pragma mark -
#pragma mark Amount

- (void)setAmount:(NSNumber *)amount {
    if ([_amount isEqualToNumber:amount]) {
        return;
    }
    
    _amount = amount ?: @0;
    
    [self reloadText];
}

- (void)setCurrencyCode:(NSString *)currencyCode {
    _currencyCode = currencyCode;
    
    [self reloadText];
    [self reloadPlaceholder];
}

#pragma mark -
#pragma mark Text

- (void)reloadText {
    NSNumber *amount = [self amount] ?: @0;
    if ([amount isEqualToNumber:@0]) {
        [self setText:nil];
    } else {
        [self setText:[self stringFromAmount:amount]];
    }
}

- (void)reloadPlaceholder {
    [self setPlaceholder:[self stringFromAmount:@0]];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSMutableString *value = [[self stringFromNumber:[self amount]] mutableCopy];
    
    if (range.length == 0) { // Indicates a new character has been added.
        // Verify if the added character is a digit.
        NSNumber *addedNumber = [self numberFromString:string];
        if (!addedNumber) {
            return NO;
        }
        
        // Append character to string.
        [value appendString:[addedNumber stringValue]];
    } else if (range.length == 1) { // Indicates a character is being deleted.
        [value deleteCharactersInRange:NSMakeRange([value length] - 1, 1)]; // Delete the last character from the string.
    }
    
    // Convert string to amount.
    NSNumber *amount = nil;
    if ([value length] > 0) {
        amount = [self numberFromString:value];
    } else if ([value length] == 0) {
        amount = @0;
    }
    
    if (!amount) {
        return NO;
    }
    
    [self setAmount:amount];
    
    [[self amountFieldDelegate] amountField:self didEnterAmount:amount];
    
    return NO;
}

#pragma mark -
#pragma mark Amount Formatter

- (NSString *)stringFromAmount:(NSNumber *)amount {
    return [AmountFormatter stringFromAmount:amount currencyCode:[self currencyCode]];
}

#pragma mark -
#pragma mark Number Formatter

- (NSNumberFormatter *)numberFormatter {
    if (_numberFormatter) {
        return _numberFormatter;
    }
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
    _numberFormatter = numberFormatter;
    
    return numberFormatter;
}

- (NSString *)stringFromNumber:(NSNumber *)number {
    return [[self numberFormatter] stringFromNumber:number];
}

- (NSNumber *)numberFromString:(NSString *)string {
    return [[self numberFormatter] numberFromString:string];
}

#pragma mark -
#pragma mark Drawing

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}
                              
@end
