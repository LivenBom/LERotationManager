//
//  AppDelegate.m
//  RotationDemo
//
//  Created by Liven on 2020/6/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [ViewController new];
    [self.window makeKeyAndVisible];
    NSLog(@"didFinishLaunchingWithOptions : %@",self.window);
    return YES;
}


- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    NSLog(@"supportedInterfaceOrientationsForWindow window %@",window);
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


@end
