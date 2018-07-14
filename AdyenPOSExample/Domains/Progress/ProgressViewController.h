//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides a progress interface for an ongoing operation with multiple steps.
 */
@interface ProgressViewController : UITableViewController

/**
 The names of the steps of the operation.
 */
@property (nonatomic, copy, readwrite, nullable) NSArray<NSString *> *steps;

/**
 The index of the current step that is being performed. An activity indicator will be shown next to the current step.
 */
@property (nonatomic, assign, readwrite) NSUInteger currentStepIndex;

/**
 The header to display above the steps.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *header;

/**
 The footer to display below the steps.
 */
@property (nonatomic, copy, readwrite, nullable) NSString *footer;

- (instancetype)init NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
