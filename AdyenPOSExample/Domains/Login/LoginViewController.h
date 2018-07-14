//
//  Copyright (c) 2017 Adyen B.V.
//
//  This file is open source and available under the MIT license. See the LICENSE file for more info.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UITableViewController

@property (nonatomic, weak, readwrite, nullable) id<LoginViewControllerDelegate> delegate;

+ (instancetype)newStoryboardInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (instancetype)initWithStyle:(UITableViewStyle)style NS_UNAVAILABLE;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)loginViewControllerDidLogin:(LoginViewController *)loginViewController;

@end

NS_ASSUME_NONNULL_END
