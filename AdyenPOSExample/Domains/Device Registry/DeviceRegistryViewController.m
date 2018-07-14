//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceRegistryViewController.h"
#import "DeviceRegistryViewDataSource.h"
#import "DeviceRegistryObserver.h"

#import "DeviceDataViewController.h"

#import <AdyenToolkit/ADYDeviceRegistry.h>
#import <AdyenToolkit/ADYDevice.h>
#import <libextobjc/EXTScope.h>

@interface DeviceRegistryViewController () <UITableViewDelegate, DeviceRegistryObserverDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DeviceRegistryViewDataSource *tableViewDataSource;

@property (nonatomic, strong, readwrite) ADYDeviceRegistry *deviceRegistry;
@property (nonatomic, strong) DeviceRegistryObserver *deviceRegistryObserver;

@end

@implementation DeviceRegistryViewController

- (instancetype)initWithDeviceRegistry:(ADYDeviceRegistry *)deviceRegistry {
    NSParameterAssert(deviceRegistry);
    
    if (self = [super init]) {
        [self setDeviceRegistry:deviceRegistry];
        
        DeviceRegistryObserver *deviceRegistryObserver = [[DeviceRegistryObserver alloc] initWithDeviceRegistry:deviceRegistry];
        [deviceRegistryObserver setDelegate:self];
        [self setDeviceRegistryObserver:deviceRegistryObserver];
        
        [self setTitle:@"Devices"];
        
        UIBarButtonItem *addDeviceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                             target:self
                                                                                             action:@selector(didSelectAddDeviceButton:)];
        [[self navigationItem] setRightBarButtonItem:addDeviceButtonItem];
        
        [[self tabBarItem] setImage:[UIImage imageNamed:@"DevicesTabBarItem"]];
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)loadView {
    DeviceRegistryViewDataSource *tableViewDataSource = [[DeviceRegistryViewDataSource alloc] initWithDeviceRegistry:[self deviceRegistry]];
    [self setTableViewDataSource:tableViewDataSource];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [tableView setDelegate:self];
    [tableView setDataSource:tableViewDataSource];
    [tableView setRowHeight:UITableViewAutomaticDimension];
    [tableView setEstimatedRowHeight:66.0f];
    [self setTableView:tableView];
    
    [tableView registerClass:[DeviceRegistryViewDataSource cellClass]
      forCellReuseIdentifier:[DeviceRegistryViewDataSource cellReuseIdentifier]];
    
    [self setView:tableView];
}

#pragma mark -
#pragma mark Add Device

- (void)didSelectAddDeviceButton:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Add Device"
                                                                             message:@"Enter the device's hostname or IP address."
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"Hostname or IP address"];
        [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    @weakify(self);
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        
        UITextField *textField = [[alertController textFields] firstObject];
        NSString *hostname = [textField text];
        if ([hostname length] == 0) {
            return;
        }
        
        [[self deviceRegistry] addDeviceWithHostname:hostname];
    }];
    [alertController addAction:addAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark Remove Device

- (void)removeDeviceAtIndexPath:(NSIndexPath *)indexPath {
    ADYDevice *device = [[self tableViewDataSource] deviceAtIndexPath:indexPath];
    if ([device connectionType] != ADYDeviceConnectionTypeWifi) { // Only devices added via Wi-Fi are removable.
        return;
    }
    
    [[self deviceRegistry] removeDeviceWithHostname:[device hostname]];
}

#pragma mark -
#pragma mark DeviceRegistryObserverDelegate

- (void)deviceRegistryObserverDeviceRegistryDidReloadDevices:(DeviceRegistryObserver *)deviceRegistryObserver {
    [[self tableView] reloadData];
}

- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceRegistryDidInsertDevicesAtIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [[self tableViewDataSource] indexPathsForDeviceIndexes:indexes];
    [[self tableView] insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceRegistryDidRemoveDevicesAtIndexes:(NSIndexSet *)indexes {
    NSArray *indexPaths = [[self tableViewDataSource] indexPathsForDeviceIndexes:indexes];
    [[self tableView] deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)deviceRegistryObserver:(DeviceRegistryObserver *)deviceRegistryObserver deviceStatusDidChangeForDeviceAtIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [[self tableViewDataSource] indexPathForDeviceAtIndex:index];
    [[self tableView] reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // Ignore unselectable cells.
    if ([cell selectionStyle] != UITableViewCellSelectionStyleDefault) {
        return;
    }
    
    ADYDevice *device = [[self tableViewDataSource] deviceAtIndexPath:indexPath];
    [[self delegate] deviceRegistryViewController:self didSelectDevice:device];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    ADYDevice *device = [[self tableViewDataSource] deviceAtIndexPath:indexPath];
    DeviceDataViewController *deviceDataViewController = [[DeviceDataViewController alloc] initWithDevice:device];
    [[self navigationController] pushViewController:deviceDataViewController animated:YES];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADYDevice *device = [[self tableViewDataSource] deviceAtIndexPath:indexPath];
    if ([device connectionType] != ADYDeviceConnectionTypeWifi) { // Only devices added via Wi-Fi are removable.
        return nil;
    }
    
    @weakify(self);
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        @strongify(self);
        
        [self removeDeviceAtIndexPath:indexPath];
    }];
    
    return @[deleteAction];
}

@end
