//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "DeviceBoardingViewController.h"

#import <AdyenToolkit/AdyenToolkit.h>
#import <AdyenToolkit/ADYDevice.h>
#import <libextobjc/EXTScope.h>

#import "UIAlertController+Error.h"

@interface DeviceBoardingViewController () <ADYDeviceManagerDelegate>

@property (nonatomic, strong, readwrite) ADYDevice *device;
@property (nonatomic, assign) BOOL didStartBoardingDevice;

@end

@implementation DeviceBoardingViewController

- (instancetype)initWithDevice:(ADYDevice *)device {
    NSParameterAssert(device);
    
    if (self = [super init]) {
        [self setDevice:device];
        
        [self setTitle:@"Boarding Device"];
        [self setSteps:@[@"Identifying device",
                         @"Registering device",
                         @"Synchronizing with Adyen",
                         @"Uploading configuration to device",
                         @"Verifying configuration on device"]];
        [self setFooter:@"After the boarding process is complete, the device will be rebooted."];
    }
    
    return self;
}

#pragma mark -
#pragma mark View

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (![self didStartBoardingDevice]) {
        [[self device] boardDeviceWithDelegate:self];
        
        [self setDidStartBoardingDevice:YES];
    }
}

#pragma mark -
#pragma mark ADYDeviceManagerDelegate

- (void)deviceManagerWillBeginStep:(ADYEMVDeviceManagerStep)step {
    [self setCurrentStepIndex:(NSUInteger)step];
}

- (void)deviceManagerDidCompleteStep:(ADYEMVDeviceManagerStep)step {
    
}

- (void)deviceManagerDidComplete {
    [[self delegate] deviceBoardingViewController:self didFinishWithError:nil];
}

- (void)deviceManagerDidFailStep:(ADYEMVDeviceManagerStep)step withError:(NSError *)error {
    @weakify(self);
    UIAlertController *alertController = [UIAlertController alertControllerWithError:error dismissActionHandler:^(UIAlertAction *action) {
        @strongify(self);
        
        [[self delegate] deviceBoardingViewController:self didFinishWithError:error];
    }];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
