//
//  AppDelegate.m
//  nommit
//
//  Created by Gregory Rose on 9/30/13.
//  Copyright (c) 2013 Gregory Rose. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MapViewController.h"
#import <VenmoAppSwitch/Venmo.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Parse Authentication
    [Parse setApplicationId:@"dVsvZKvNezm6oWEGL8kSILAXrABkQXYZEuMyt5SZ"
                  clientKey:@"yKsBX1LAPLgYlVvLfWfkYux4DDrAOQDFJ3R9iUKa"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Google Maps API
    [GMSServices provideAPIKey:@"AIzaSyA8S2dgTX-m-gxcsDyDPBOQkwSvaZ3Puvo"];
    
    //Venmo
    
    VenmoClient *venmoClient = [VenmoClient clientWithAppId:@"1422" secret:@"s5z3FenAVb7YYFPNbNKcHfeby6ACZMrV"];
    
    VenmoTransaction *venmoTransaction = [[VenmoTransaction alloc] init];
    venmoTransaction.type = VenmoTransactionTypePay;
    venmoTransaction.amount = [NSDecimalNumber decimalNumberWithString:@"0.05"];
    venmoTransaction.note = @"hello world";
    venmoTransaction.toUserHandle = @"matthewhamilton";
    
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[MapViewController alloc] init]];
    
    // Override point for customization after application launch.
    //self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.window.rootViewController presentViewController:navController animated:YES completion:nil];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
