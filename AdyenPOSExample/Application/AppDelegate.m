//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIColor *tintColor = [UIColor colorWithRed:(10.0/255.0f) green:(191.0f/255.0f) blue:(83.0f/255.0f) alpha:1.0f];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window setTintColor:tintColor];
    [window setRootViewController:[RootViewController new]];
    [window makeKeyAndVisible];
    [self setWindow:window];
    
    return YES;
}

@end
