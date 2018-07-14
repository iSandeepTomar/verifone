//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "ProgressViewController.h"
#import "ProgressViewStepCell.h"

@interface ProgressViewController ()

@end

@implementation ProgressViewController

- (instancetype)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {
        
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [self tableView];
    [tableView registerClass:[ProgressViewStepCell class] forCellReuseIdentifier:@"StepCell"];
}

#pragma mark -
#pragma mark Steps

- (void)setSteps:(NSArray<NSString *> *)steps {
    _steps = steps;
    
    if ([self isViewLoaded]) {
        [[self tableView] reloadData];
    }
}

- (void)setCurrentStepIndex:(NSUInteger)currentStepIndex {
    NSUInteger previousStepIndex = _currentStepIndex;
    
    _currentStepIndex = currentStepIndex;
    
    if (![self isViewLoaded]) {
        return;
    }
    
    UITableView *tableView = [self tableView];
    
    NSIndexPath *previousIndexPath = [NSIndexPath indexPathForRow:previousStepIndex inSection:0];
    ProgressViewStepCell *previousCell = [tableView cellForRowAtIndexPath:previousIndexPath];
    [previousCell setState:[self stateForCellAtIndexPath:previousIndexPath]];
    
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:currentStepIndex inSection:0];
    ProgressViewStepCell *currentCell = [tableView cellForRowAtIndexPath:currentIndexPath];
    [currentCell setState:[self stateForCellAtIndexPath:currentIndexPath]];
}

- (NSString *)stepAtIndexPath:(NSIndexPath *)indexPath {
    return [[self steps] objectAtIndex:[indexPath row]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self header];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self footer];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self steps] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProgressViewStepCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StepCell" forIndexPath:indexPath];
    [cell setStep:[self stepAtIndexPath:indexPath]];
    [cell setState:[self stateForCellAtIndexPath:indexPath]];
    
    return cell;
}

- (ProgressViewStepCellState)stateForCellAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger stepIndex = [indexPath row];
    NSUInteger currentStepIndex = [self currentStepIndex];
    
    if (stepIndex < currentStepIndex) {
        return ProgressViewStepCellStateFinished;
    } else if (stepIndex == currentStepIndex) {
        return ProgressViewStepCellStateExecuting;
    } else if (stepIndex > currentStepIndex) {
        return ProgressViewStepCellStateReady;
    }
    
    return ProgressViewStepCellStateReady;
}

@end
