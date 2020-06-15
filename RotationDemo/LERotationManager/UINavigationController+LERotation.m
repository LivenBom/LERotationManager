//
//  UINavigationController+LERotation.m
//  RotationDemo
//
//  Created by Liven on 2020/6/15.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UINavigationController+LERotation.h"

@implementation UINavigationController (LERotation)

- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}
 

@end
