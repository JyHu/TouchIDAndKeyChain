//
//  AppDelegate.m
//  LoginWithTouchID
//
//  Created by 胡金友 on 16/3/2.
//  Copyright © 2016年 胡金友. All rights reserved.
//

#import "AppDelegate.h"
#import "NavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[NavigationViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
