//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "ProgressViewStepCell.h"

@implementation ProgressViewStepCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [self setStep:nil];
    [self setState:ProgressViewStepCellStateReady];
}

#pragma mark -
#pragma mark Step

- (void)setStep:(NSString *)step {
    _step = [step copy];
    
    [[self textLabel] setText:step];
}

#pragma mark -
#pragma mark State

- (void)setState:(ProgressViewStepCellState)state {
    if (state == _state) {
        return;
    }
    
    _state = state;
    
    UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
    UIView *accessoryView = nil;
    UIColor *textColor = [UIColor blackColor];
    
    switch (state) {
        case ProgressViewStepCellStateReady:
            textColor = [UIColor grayColor];
            
            break;
        case ProgressViewStepCellStateExecuting:
            accessoryView = [self newActivityIndicatorView];
            
            break;
        case ProgressViewStepCellStateFinished:
            accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
    }
    
    [self setAccessoryType:accessoryType];
    [self setAccessoryView:accessoryView];
}

#pragma mark -
#pragma mark Helpers

- (UIActivityIndicatorView *)newActivityIndicatorView {
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicatorView startAnimating];
    [activityIndicatorView sizeToFit];
    
    return activityIndicatorView;
}

@end
