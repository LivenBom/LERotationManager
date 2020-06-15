
//
//  RotationManagerDefines.h
//  RotationDemo
//
//  Created by Liven on 2020/6/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#ifndef LERotationManagerDefines_h
#define LERotationManagerDefines_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LEOrientation) {
    LEOrientation_Portrait = UIDeviceOrientationPortrait,
    LEOrientation_LandscapeLeft = UIDeviceOrientationLandscapeLeft,
    LEOrientation_LandscapeRight = UIDeviceOrientationLandscapeRight,
};

typedef enum : NSUInteger {
    LEOrientationMaskPortrait = 1 << LEOrientation_Portrait,
    LEOrientationMaskLandscapeLeft = 1 << LEOrientation_LandscapeLeft,
    LEOrientationMaskLandscapeRight = 1 << LEOrientation_LandscapeRight,
    LEOrientationMaskAll = LEOrientationMaskPortrait | LEOrientationMaskLandscapeLeft | LEOrientationMaskLandscapeRight,
} LEOrientationMask;


@protocol LERotationManagerDelegate <NSObject>

/// 是否可以旋转
@property (nonatomic, copy ,nullable) BOOL(^shouldTriggerRotation)(id<LERotationManagerDelegate> _Nullable mgr) ;


/// 是否禁止自动旋转
/// 该属性只会禁止自动旋转，当调用 rotate 方法还是可以旋转的
/// 默认 false
@property (nonatomic, assign,getter=isDisableAutorotation) BOOL  disbleAutorotation;


/// 自动旋转时，所支持的方法
/// 默认是 all
@property (nonatomic, assign) LEOrientationMask  autorotationSupportedOrientations;


/// 旋转
- (void)rotate;


/// 旋转到指定的方向
/// @param orientation orientation
/// @param animated animated
- (void)rotate:(LEOrientation)orientation animated:(BOOL)animated;


/// 旋转到指定的方向
/// @param orientation orientation
/// @param animated animated
/// @param completionHandler completionHandler
- (void)rotate:(LEOrientation)orientation animated:(BOOL)animated completionHandler:(nullable void(^)(id<LERotationManagerDelegate> _Nullable mgr))completionHandler;


/// 当前的方向
@property (nonatomic, assign, readonly) LEOrientation currentOrientation;
/// 是否全屏
@property (nonatomic, assign, readonly) BOOL  isFullScreen;
/// 是否正在旋转
@property (nonatomic, assign, getter=isTransitioning,readonly) BOOL  transitioning;


/// 废弃不使用
@property (nonatomic, weak, nullable) UIView  *superView;
/// 要旋转的页面
@property (nonatomic, weak, nullable) UIView  *target;

@end



#endif /* LERotationManagerDefines_h */
