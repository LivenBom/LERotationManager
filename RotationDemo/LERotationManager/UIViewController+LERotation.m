//
//  UIViewController+LERotation.m
//  RotationDemo
//
//  Created by Liven on 2020/6/12.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UIViewController+LERotation.h"
#import <objc/runtime.h>

@implementation UIViewController (LERotation)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = [self class];

        SEL originSelector = @selector(shouldAutorotate);
        SEL swizzledSelector = @selector(le_shouldAutorotate);

        Method originMethod = class_getInstanceMethod(cls, originSelector);
        Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);

        BOOL didAddMethod = class_addMethod(cls, originSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(cls, swizzledSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else{
            method_exchangeImplementations(originMethod, swizzledMethod);
        }
    });
}

- (BOOL)le_shouldAutorotate {
    return NO;
}

@end
