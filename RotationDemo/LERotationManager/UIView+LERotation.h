//
//  UIView+LERotation.h
//  RotationDemo
//
//  Created by Liven on 2020/6/12.
//  Copyright © 2020 Liven. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LERotation)


/// 寻找响应者cls
/// @param cls cls
- (__kindof UIResponder *_Nullable)lookupResponderForClass:(Class)cls;

@end

NS_ASSUME_NONNULL_END
