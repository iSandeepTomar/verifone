//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "LoginViewController.h"

#import "UIAlertController+Error.h"

#import <AdyenToolkit/Adyen.h>
#import <JGProgressHUD/JGProgressHUD.h>

@interface LoginViewController () <ADYLoginDelegate>

@property (nonatomic, weak) IBOutlet UITextField *merchantAccountField;
@property (nonatomic, weak) IBOutlet UITextField *usernameField;
@property (nonatomic, weak) IBOutlet UITextField *passwordField;

@property (nonatomic, strong) JGProgressHUD *progressHUD;

@end

@implementation LoginViewController

+ (instancetype)newStoryboardInstance {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
    LoginViewController *viewController = [storyboard instantiateInitialViewController];
    
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Login"];
}

#pragma mark -
#pragma mark Login

- (void)login {
    NSString *merchantAccount = [[self merchantAccountField] text];
    NSString *username = [[self usernameField] text];
    NSString *password = [[self passwordField] text];
    
    if ([merchantAccount length] == 0 || [username length] == 0 || [password length] == 0) {
        return;
    }
    
    [self disableLoginFields];
    
    [[self progressHUD] showInView:[self view]];
    
    [[Adyen sharedInstance] loginWithMerchantCode:merchantAccount withUsername:username withPassword:password andDelegate:self];
}

- (void)enableLoginFields {
    NSArray *fields = @[[self merchantAccountField], [self usernameField], [self passwordField]];
    for (UITextField *field in fields) {
        [field setEnabled:YES];
    }
}

- (void)disableLoginFields {
    NSArray *fields = @[[self merchantAccountField], [self usernameField], [self passwordField]];
    for (UITextField *field in fields) {
        [field setEnabled:NO];
    }
}

#pragma mark -
#pragma mark Progress HUD

- (JGProgressHUD *)progressHUD {
    if (_progressHUD) {
        return _progressHUD;
    }
    
    JGProgressHUD *progressHUD = [[JGProgressHUD alloc] initWithStyle:JGProgressHUDStyleDark];
    [progressHUD setIndicatorView:[JGProgressHUDRingIndicatorView new]];
    _progressHUD = progressHUD;
    
    return progressHUD;
}

#pragma mark -
#pragma mark ADYLoginDelegate

- (void)loginUpdatedProgress:(float)progress status:(ADYLoginDelegateStatus)status {
    [[self progressHUD] setProgress:progress animated:YES];
}

- (void)loginCompletedSuccessfullyWithInfo:(NSDictionary *)info {
    [self enableLoginFields];
    
    [[self progressHUD] dismiss];
    
    [[self delegate] loginViewControllerDidLogin:self];
}

- (void)loginFailedWithError:(NSError *)error {
    [[self progressHUD] dismiss];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithError:error];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([indexPath section] == 1) {
        [self login];
    }
}

@end
