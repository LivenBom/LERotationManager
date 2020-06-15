//
//  UIView+LERotation.m
//  RotationDemo
//
//  Created by Liven on 2020/6/12.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "UIView+LERotation.h"

@implementation UIView (LERotation)

/// 寻找响应者cls
/// @param cls cls
- (__kindof UIResponder *_Nullable)lookupResponderForClass:(Class)cls {
    __kindof UIResponder *_Nullable next = self.nextResponder;
    while (next != nil && [next isKindOfClass:cls] == NO) {
        next = next.nextResponder;
    }
    return next;
}

@end
