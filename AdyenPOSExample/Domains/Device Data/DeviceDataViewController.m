//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceDataViewController.h"
#import "DeviceDataViewDataSource.h"

#import <AdyenToolkit/ADYDevice.h>
#import <libextobjc/EXTScope.h>

#import "UIAlertController+Error.h"

@interface DeviceDataViewController () <UITableViewDelegate>

@property (nonatomic, strong) ADYDevice *device;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DeviceDataViewDataSource *tableViewDataSource;

@end

@implementation DeviceDataViewController

- (instancetype)initWithDevice:(ADYDevice *)device {
    NSParameterAssert(device);
    
    if (self = [super initWithNibName:nil bundle:nil]) {
        [self setDevice:device];
        
        [self setTitle:[device name]];
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)loadView {
    [self setView:[self tableView]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestDeviceData];
}

#pragma mark -
#pragma mark Table View

- (UITableView *)tableView {
    if (_tableView) {
        return _tableView;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setDataSource:[self tableViewDataSource]];
    [tableView setDelegate:self];
    
    [tableView registerClass:[DeviceDataViewDataSource cellClass]
      forCellReuseIdentifier:[DeviceDataViewDataSource cellReuseIdentifier]];
    
    _tableView = tableView;
    
    return tableView;
}

- (DeviceDataViewDataSource *)tableViewDataSource {
    if (_tableViewDataSource) {
        return _tableViewDataSource;
    }
    
    ADYDevice *device = [self device];
    
    DeviceDataViewDataSource *tableViewDataSource = [[DeviceDataViewDataSource alloc] initWithDevice:device];
    [tableViewDataSource setDeviceData:[device deviceData]];
    _tableViewDataSource = tableViewDataSource;
    
    return tableViewDataSource;
}

#pragma mark -
#pragma mark Device Data

- (void)requestDeviceData {
    @weakify(self);
    [[self device] getDeviceDataWithCompletion:^(ADYDeviceData *deviceData, NSError *error) {
        @strongify(self);
        
        if (!self) {
            return;
        }
        
        if (deviceData) {
            [[self tableViewDataSource] setDeviceData:deviceData];
            [[self tableView] reloadData];
        } else if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithError:error];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

@end
