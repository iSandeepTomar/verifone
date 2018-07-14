//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "TransactionsViewCell.h"

@interface TransactionsViewCell ()

@property (nonatomic, strong) UILabel *referenceLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *amountLabel;

@end

@implementation TransactionsViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configure];
    }
    
    return self;
}

- (void)configure {
    UIView *contentView = [self contentView];
    [contentView addSubview:[self referenceLabel]];
    [contentView addSubview:[self stateLabel]];
    [contentView addSubview:[self amountLabel]];
    
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self configureConstraints];
}

- (void)configureConstraints {
    UILabel *referenceLabel = [self referenceLabel];
    UILabel *stateLabel = [self stateLabel];
    UILabel *amountLabel = [self amountLabel];
    
    UILayoutGuide *layoutGuide = [[self contentView] layoutMarginsGuide];
    
    NSArray *constraints = @[[[referenceLabel topAnchor] constraintEqualToAnchor:[layoutGuide topAnchor]],
                             [[referenceLabel leadingAnchor] constraintEqualToAnchor:[layoutGuide leadingAnchor]],
                             [[referenceLabel trailingAnchor] constraintEqualToAnchor:[layoutGuide trailingAnchor]],
                             
                             [[stateLabel topAnchor] constraintEqualToAnchor:[referenceLabel bottomAnchor]],
                             [[stateLabel leadingAnchor] constraintEqualToAnchor:[layoutGuide leadingAnchor]],
                             [[stateLabel trailingAnchor] constraintEqualToAnchor:[layoutGuide trailingAnchor]],
                             [[stateLabel bottomAnchor] constraintEqualToAnchor:[layoutGuide bottomAnchor]],
                             
                             [[amountLabel centerYAnchor] constraintEqualToAnchor:[layoutGuide centerYAnchor]],
                             [[amountLabel trailingAnchor] constraintEqualToAnchor:[layoutGuide trailingAnchor]]];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark -
#pragma mark Reference Label

- (void)setReference:(NSString *)reference {
    _reference = [reference copy];
    
    [[self referenceLabel] setText:reference];
}

- (UILabel *)referenceLabel {
    if (_referenceLabel) {
        return _referenceLabel;
    }
    
    UILabel *referenceLabel = [[UILabel alloc] init];
    [referenceLabel setFont:[UIFont systemFontOfSize:17.0]];
    [referenceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _referenceLabel = referenceLabel;
    
    return referenceLabel;
}

#pragma mark -
#pragma mark State Label

- (void)setState:(NSString *)state {
    _state = [state copy];
    
    [[self stateLabel] setText:state];
}

- (UILabel *)stateLabel {
    if (_stateLabel) {
        return _stateLabel;
    }
    
    UILabel *stateLabel = [[UILabel alloc] init];
    [stateLabel setFont:[UIFont systemFontOfSize:15.0]];
    [stateLabel setTextColor:[UIColor grayColor]];
    [stateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _stateLabel = stateLabel;
    
    return stateLabel;
}

#pragma mark -
#pragma mark Amount Label

- (void)setAmount:(NSString *)amount {
    _amount = [amount copy];
    
    [[self amountLabel] setText:amount];
}

- (UILabel *)amountLabel {
    if (_amountLabel) {
        return _amountLabel;
    }
    
    UILabel *amountLabel = [[UILabel alloc] init];
    [amountLabel setFont:[UIFont systemFontOfSize:15.0]];
    [amountLabel setTextColor:[UIColor lightGrayColor]];
    [amountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _amountLabel = amountLabel;
    
    return amountLabel;
}

@end
