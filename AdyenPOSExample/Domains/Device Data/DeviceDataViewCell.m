//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceDataViewCell.h"

@implementation DeviceDataViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)setKey:(NSString *)key {
    _key = [key copy];
    
    [[self textLabel] setText:key];
}

- (void)setValue:(NSString *)value {
    _value = [value copy];
    
    [[self detailTextLabel] setText:value];
}

@end
