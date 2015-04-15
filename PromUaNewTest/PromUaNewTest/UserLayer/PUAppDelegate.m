//
//  PUAppDelegate.m
//  PromUaNewTest
//
//  Created by rost on 13.04.15.
//  Copyright (c) 2015 Rost. All rights reserved.
//

#import "PUAppDelegate.h"
#import "PUOrdersViewController.h"


@implementation PUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    PUOrdersViewController *ordersVC = [[PUOrdersViewController alloc] init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:ordersVC];
    self.window.rootViewController = _navigationController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[PUDataFetcher shared] saveContext];
}

@end
