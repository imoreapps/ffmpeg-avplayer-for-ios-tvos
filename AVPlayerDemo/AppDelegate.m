//
//  AppDelegate.m
//  AVPlayerDemo
//
//  Created by apple on 2/4/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "AppDelegate.h"
#import <AVPlayerTouch/AVPlayerTouch.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [AVPLicense register:@"Nm/MZujYcAA+1eN7kDZbptapARjSGFARVjBN+dZplEmrAf6XKxJQ2S7Axr2446WDTBkfomhGUzVaEGcfE0+PINW0lGEUu4XZlgyJL0mXwNBm4EJ8DzsMol2hG53GZKkBhm2fdhFA/vq+YZuvsJ2dctOqTf4WuIUCdx3gP/+jiUTj+X/tGhmjp3SIcS8yncItukjlVx9L5SkhCH7KfIQTAsjAVlgRM6/xWd6yDwVPViE="];
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
