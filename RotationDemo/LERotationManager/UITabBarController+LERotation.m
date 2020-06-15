//
//  UITabBarController+LERotation.m
//  RotationDemo
//
//  Created by Liven on 2020/6/15.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UITabBarController+LERotation.h"

@implementation UITabBarController (LERotation)

- (BOOL)shouldAutorotate {
    return self.selectedViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.selectedViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.selectedViewController.preferredInterfaceOrientationForPresentation;
}

@end
