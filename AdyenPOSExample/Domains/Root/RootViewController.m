//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "RootViewController.h"
#import "LoginViewController.h"
#import "DeviceRegistryViewController.h"
#import "DeviceBoardingViewController.h"
#import "TransactionViewController.h"
#import "TransactionsViewController.h"

#import <AdyenToolkit/Adyen.h>
#import <AdyenToolkit/ADYDevice.h>
#import <JGProgressHUD/JGProgressHUD.h>

#import "NSArray+Helpers.h"
#import "UIAlertController+Error.h"

@interface RootViewController () <LoginViewControllerDelegate, DeviceRegistryViewControllerDelegate, DeviceBoardingViewControllerDelegate, TransactionViewControllerDelegate>

@end

@implementation RootViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configureViewControllers];
    }
    
    return self;
}

- (void)configureViewControllers {
    DeviceRegistryViewController *deviceRegistryViewController = [[DeviceRegistryViewController alloc] initWithDeviceRegistry:[[Adyen sharedInstance] deviceRegistry]];
    [deviceRegistryViewController setDelegate:self];
    
    TransactionsViewController *transactionsViewController = [TransactionsViewController new];
    
    NSArray *viewControllers = @[deviceRegistryViewController, transactionsViewController];
    for (UIViewController *viewController in viewControllers) {
        UIBarButtonItem *logoutButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log out" style:UIBarButtonItemStylePlain target:self action:@selector(didSelectLogoutButton:)];
        [[viewController navigationItem] setLeftBarButtonItem:logoutButtonItem];
    }
    
    NSArray *navigationControllers = [viewControllers arrayByMappingObjectsUsingBlock:^id(UIViewController *viewController) {
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    }];
    [self setViewControllers:navigationControllers];
}

#pragma mark -
#pragma mark View

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![self isLoggedIn]) {
        [self presentLoginViewController];
    }
}

#pragma mark -
#pragma mark Login

- (BOOL)isLoggedIn {
    return [[Adyen sharedInstance] loginStatus] == ADYLoginStatusLoggedIn;
}

- (void)presentLoginViewController {
    LoginViewController *loginViewController = [LoginViewController newStoryboardInstance];
    [loginViewController setDelegate:self];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)loginViewControllerDidLogin:(LoginViewController *)loginViewController {
    [[loginViewController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Logout

- (void)didSelectLogoutButton:(UIBarButtonItem *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:@"Are you sure you want to log out?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:@"Log out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self logout];
    }];
    [alertController addAction:logoutAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    [[alertController popoverPresentationController] setBarButtonItem:sender];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)logout {
    JGProgressHUD *progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    [[progressHUD textLabel] setText:@"Logging out..."];
    [progressHUD showInView:[self view]];
    
    [[Adyen sharedInstance] logoutWithCompletion:^(NSError *error) {
        [progressHUD dismiss];
        
        if (error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithError:error];
            [self presentViewController:alertController animated:YES completion:nil];
        } else {
            [self presentLoginViewController];
        }
    }];
}

#pragma mark -
#pragma mark Device Registry View Controller

- (void)deviceRegistryViewController:(DeviceRegistryViewController *)deviceRegistryViewController didSelectDevice:(ADYDevice *)device {
    if ([device status] == ADYDeviceStatusInitialized) {
        [self presentTransactionViewControllerForDevice:device];
    } else if ([device status] == ADYDeviceStatusNotBoarded) {
        [self presentDeviceBoardingViewControllerForDevice:device];
    }
}

#pragma mark -
#pragma mark Device Boarding View Controller

- (void)presentDeviceBoardingViewControllerForDevice:(ADYDevice *)device {
    DeviceBoardingViewController *deviceBoardingViewController = [[DeviceBoardingViewController alloc] initWithDevice:device];
    [deviceBoardingViewController setDelegate:self];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:deviceBoardingViewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)deviceBoardingViewController:(DeviceBoardingViewController *)deviceBoardingViewController didFinishWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Transaction View Controller

- (void)presentTransactionViewControllerForDevice:(ADYDevice *)device {
    TransactionViewController *transactionViewController = [[TransactionViewController alloc] initWithDevice:device];
    [transactionViewController setDelegate:self];
    [self presentViewController:transactionViewController animated:YES completion:nil];
}

- (void)transactionViewControllerDidFinish:(TransactionViewController *)transactionViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
