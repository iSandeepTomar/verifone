//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceDataViewDataSource.h"
#import "DeviceDataViewSection.h"
#import "DeviceDataViewItem.h"
#import "DeviceDataViewCell.h"

#import <AdyenToolkit/ADYDevice.h>
#import <AdyenToolkit/ADYDeviceData.h>

#import "NSStringFromADYDeviceStatus.h"

@interface DeviceDataViewDataSource ()

@property (nonatomic, strong, readwrite) ADYDevice *device;

@property (nonatomic, copy) NSArray *sections;

@end

@implementation DeviceDataViewDataSource

- (instancetype)initWithDevice:(ADYDevice *)device {
    NSParameterAssert(device);
    
    if (self = [super init]) {
        [self setDevice:device];
    }
    
    return self;
}

#pragma mark -
#pragma mark Cell

+ (Class)cellClass {
    return [DeviceDataViewCell class];
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self cellClass]);
}

#pragma mark -
#pragma mark Device Data

- (void)setDeviceData:(ADYDeviceData *)deviceData {
    _deviceData = deviceData;
    
    if (!deviceData) {
        [self setSections:nil];
        
        return;
    }
    
    ADYDevice *device = [self device];
    
    // Status section
    NSArray *statusItems = @[[DeviceDataViewItem itemWithKey:@"Status" value:NSStringFromADYDeviceStatus([device status])],
                             [DeviceDataViewItem itemWithKey:@"Battery" value:[[[deviceData batteryPercentage] stringValue] stringByAppendingString:@"%"]],
                             [DeviceDataViewItem itemWithKey:@"Hostname" value:[device hostname]]];
    DeviceDataViewSection *statusSection = [DeviceDataViewSection sectionWithTitle:@"Status" items:statusItems];
    
    // Terminal section
    NSArray *terminalItems = @[[DeviceDataViewItem itemWithKey:@"Identifier" value:[deviceData terminalId]],
                               [DeviceDataViewItem itemWithKey:@"Brand" value:[deviceData terminalBrand]],
                               [DeviceDataViewItem itemWithKey:@"Type" value:[deviceData terminalType]],
                               [DeviceDataViewItem itemWithKey:@"Name" value:[deviceData terminalConfiguredName]],
                               [DeviceDataViewItem itemWithKey:@"Serial Number" value:[deviceData terminalSerialNumber]]];
    DeviceDataViewSection *terminalSection = [DeviceDataViewSection sectionWithTitle:@"Terminal" items:terminalItems];
    
    // Version section
    NSArray *versionItems = @[[DeviceDataViewItem itemWithKey:@"OS Version" value:[deviceData terminalOsVersion]],
                              [DeviceDataViewItem itemWithKey:@"Hardware Version" value:[deviceData terminalHardwareVersion]],
                              [DeviceDataViewItem itemWithKey:@"API Version" value:[deviceData terminalApiVersion]],
                              [DeviceDataViewItem itemWithKey:@"API Upgrade Version" value:[deviceData terminalApiVersionUpgrade]],
                              [DeviceDataViewItem itemWithKey:@"Interface Version" value:[deviceData interfaceVersion]]];
    DeviceDataViewSection *versionSection = [DeviceDataViewSection sectionWithTitle:@"Version" items:versionItems];
    
    // Account section
    NSArray *accountItems = @[[DeviceDataViewItem itemWithKey:@"Accounts" value:[[deviceData terminalMerchantAccounts] componentsJoinedByString:@", "]],
                              [DeviceDataViewItem itemWithKey:@"Live" value:[deviceData live] ? @"Yes" : @"No"]];
    DeviceDataViewSection *accountSection = [DeviceDataViewSection sectionWithTitle:@"Account" items:accountItems];
    
    [self setSections:@[statusSection, terminalSection, versionSection, accountSection]];
}

#pragma mark -
#pragma mark Sections and Items

- (DeviceDataViewSection *)sectionAtIndex:(NSUInteger)index {
    return [[self sections] objectAtIndex:index];
}

- (DeviceDataViewItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
    DeviceDataViewSection *section = [self sectionAtIndex:[indexPath section]];
    
    return [[section items] objectAtIndex:[indexPath row]];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self sectionAtIndex:section] title];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[self sectionAtIndex:section] items] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceDataViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[DeviceDataViewDataSource cellReuseIdentifier] forIndexPath:indexPath];
    
    DeviceDataViewItem *item = [self itemAtIndexPath:indexPath];
    [cell setKey:[item key]];
    [cell setValue:[item value]];
    
    return cell;
}

@end
