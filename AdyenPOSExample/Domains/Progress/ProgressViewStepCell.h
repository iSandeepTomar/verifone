//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Enum specifying the different possible states of the `ProgressViewStepCell`.
 */
typedef NS_ENUM(NSUInteger, ProgressViewStepCellState) {
    
    /// Indicates that the step is waiting to be performed.
    ProgressViewStepCellStateReady,
    
    /// Indicates that the step is being performed.
    ProgressViewStepCellStateExecuting,
    
    /// Indicates that the step has been performed.
    ProgressViewStepCellStateFinished
    
};

/**
 A cell that displays a step in an operation of a `ProgressViewController`.
 */
@interface ProgressViewStepCell : UITableViewCell

/**
 The step displayed by the cell.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *step;

/**
 The current state of the step displayed in the cell.
 */
@property (nonatomic, assign, readwrite) ProgressViewStepCellState state;

@end

NS_ASSUME_NONNULL_END
