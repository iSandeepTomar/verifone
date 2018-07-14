//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceRegistryViewCell.h"

@interface DeviceRegistryViewCell ()

@property (nonatomic, strong) UIImageView *connectionIconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *statusLabel;

@end

@implementation DeviceRegistryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        [self configure];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setConnectionIcon:DeviceRegistryViewCellConnectionIconMFI];
    [self setName:nil];
    [self setStatus:nil];
}

#pragma mark -
#pragma mark Configuration

- (void)configure {
    UIView *contentView = [self contentView];
    [contentView addSubview:[self connectionIconView]];
    [contentView addSubview:[self nameLabel]];
    [contentView addSubview:[self statusLabel]];
    
    [self configureConstraints];
}

- (void)configureConstraints {
    UIView *contentView = [self contentView];
    UIImageView *connectionIconView = [self connectionIconView];
    UILabel *nameLabel = [self nameLabel];
    UILabel *statusLabel = [self statusLabel];
    
    UILayoutGuide *layoutGuide = [contentView layoutMarginsGuide];
    
    NSArray *constraints = @[[[connectionIconView centerYAnchor] constraintEqualToAnchor:[layoutGuide centerYAnchor]],
                             [[connectionIconView leadingAnchor] constraintEqualToAnchor:[layoutGuide leadingAnchor]],
                             [[connectionIconView widthAnchor] constraintEqualToConstant:18.0f],
                             [[connectionIconView heightAnchor] constraintEqualToConstant:18.0f],
                             
                             [[nameLabel topAnchor] constraintEqualToAnchor:[layoutGuide topAnchor]],
                             [[nameLabel leadingAnchor] constraintEqualToAnchor:[connectionIconView trailingAnchor] constant:15.0f],
                             [[nameLabel trailingAnchor] constraintEqualToAnchor:[layoutGuide trailingAnchor]],
                             
                             [[statusLabel topAnchor] constraintEqualToAnchor:[nameLabel bottomAnchor]],
                             [[statusLabel leadingAnchor] constraintEqualToAnchor:[nameLabel leadingAnchor]],
                             [[statusLabel trailingAnchor] constraintEqualToAnchor:[layoutGuide trailingAnchor]],
                             [[statusLabel bottomAnchor] constraintEqualToAnchor:[layoutGuide bottomAnchor]]];
    [NSLayoutConstraint activateConstraints:constraints];
}

#pragma mark -
#pragma mark Connection Icon View

- (void)setConnectionIcon:(DeviceRegistryViewCellConnectionIcon)connectionIcon {
    _connectionIcon = connectionIcon;
    
    UIImageView *connectionIconView = [self connectionIconView];
    if (connectionIcon == DeviceRegistryViewCellConnectionIconMFI) {
        [connectionIconView setImage:[UIImage imageNamed:@"DeviceConnectionMFI"]];
    } else if (connectionIcon == DeviceRegistryViewCellConnectionIconWiFi) {
        [connectionIconView setImage:[UIImage imageNamed:@"DeviceConnectionWiFi"]];
    }
}

- (UIImageView *)connectionIconView {
    if (_connectionIconView) {
        return _connectionIconView;
    }
    
    UIImageView *connectionIconView = [[UIImageView alloc] init];
    [connectionIconView setContentMode:UIViewContentModeCenter];
    [connectionIconView setTranslatesAutoresizingMaskIntoConstraints:NO];
    _connectionIconView = connectionIconView;
    
    return connectionIconView;
}

#pragma mark -
#pragma mark Name Label

- (void)setName:(NSString *)name {
    _name = [name copy];
    
    [[self nameLabel] setText:name];
}

- (UILabel *)nameLabel {
    if (_nameLabel) {
        return _nameLabel;
    }
    
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFont:[UIFont systemFontOfSize:17.0]];
    [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _nameLabel = nameLabel;
    
    return nameLabel;
}

#pragma mark -
#pragma mark Status Label

- (void)setStatus:(NSString *)status {
    _status = [status copy];
    
    [[self statusLabel] setText:status];
}

- (UILabel *)statusLabel {
    if (_statusLabel) {
        return _statusLabel;
    }
    
    UILabel *statusLabel = [[UILabel alloc] init];
    [statusLabel setFont:[UIFont systemFontOfSize:15.0]];
    [statusLabel setTextColor:[UIColor grayColor]];
    [statusLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    _statusLabel = statusLabel;
    
    return statusLabel;
}

#pragma mark -
#pragma mark Detail Button

- (void)setShowsDetailButton:(BOOL)showsDetailButton {
    _showsDetailButton = showsDetailButton;
    
    if (showsDetailButton) {
        [self setAccessoryType:UITableViewCellAccessoryDetailButton];
    } else {
        [self setAccessoryType:UITableViewCellAccessoryNone];
    }
}

@end
