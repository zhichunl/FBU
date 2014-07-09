//
//  INLAppDelegate.m
//  Inlink
//
//  Created by Ruoxi Tan on 7/7/14.
//  Copyright (c) 2014 Inlink. All rights reserved.
//

#import "INLAppDelegate.h"
#import "INLloginViewController.h"
#import "INLContactsTableViewController.h"
#import "INLAddFriendsViewController.h"
#import "INLAcceptFriendshipTableViewController.h"
#import "INLChatViewController.h"
#import <Parse/Parse.h>
#import "INLloginViewController.h"
#import "INLsignUpViewController.h"

@implementation INLAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"g20pic1llOjxp3NbQ0K2BOlZUyuV2wkB6NA5pfvD"
                  clientKey:@"8wNnr3kV0jrq1w6gzofaNCR2YTmUeCIuoWxJb5sx"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    //EXTRA DECLARATIONS for no reason Lol
    INLloginViewController *login = [[INLloginViewController alloc]init];
    
    //Navigation
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];

    self.window.rootViewController = nav;
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    //Change tint of nav bar
    [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:0.278 green:0.859 blue:1 alpha:1]];
    
    return YES;
}

//For Push Notifications
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
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
