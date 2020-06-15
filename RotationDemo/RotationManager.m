//
//  RotationManager.m
//  RotationDemo
//
//  Created by Liven on 2020/6/11.
//  Copyright © 2020 Liven. All rights reserved.
//

/**
 #笔记#
 1.0 修改设备方向有两种方式
    第一种：设备自带的加速器
    第二种：手动设置
         [UIDevice.currentDevice setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
         [UIDevice.currentDevice setValue:@(orientation) forKey:@"orientation"];
 
 2.0 控制设备的方向与界面方向的统一，由navigationController、viewController中的方法shouldAutorotate返回的值决定，如果是YES，这界面会旋转，否则则不会变化
 
 3.0
 
 */

#import "LERotationManager.h"
#import <UIKit/UIKit.h>
#import "UIView+Rotation.h"

static NSNotificationName const RotationManagerTransitioningValueDidChangeNotificaiton = @"RotationManagerTransitioningValueDidChangeNotificaiton";


#pragma mark - ViewController
@class FullScreenModeViewController;
@protocol FullScreenModelViewControllerDelegate <NSObject>
- (UIView *)target;
- (CGRect)targetOriginFrame;
- (BOOL)preferStatusBarHidden;
- (UIStatusBarStyle)preferredStatusBarStyle;

- (BOOL)shouldAutorotateToOrientation:(UIDeviceOrientation)orientation;
- (void)fullScreenModelViewController:(FullScreenModeViewController *)vc willRotateToOrientation:(UIDeviceOrientation)orientation;
- (void)fullScreenModelViewController:(FullScreenModeViewController *)vc didRotateFromOrientation:(UIDeviceOrientation)orientation;

@end


@interface FullScreenModeViewController : UIViewController
@property (nonatomic,  weak ) id<FullScreenModelViewControllerDelegate>  delegate;
@property (nonatomic, assign) BOOL  isFullScreen;
@property (nonatomic, assign) BOOL  disableAnimations;
@property (nonatomic, assign,getter=isRotating) BOOL  rotating;
@property (nonatomic, assign) UIDeviceOrientation  currentOrientation;
@end

@implementation FullScreenModeViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        _rotating = NO;
        _isFullScreen = NO;
        _disableAnimations = NO;
        _currentOrientation = UIDeviceOrientationPortrait;
    }
    return self;
}

/// 是否支持自动旋转
- (BOOL)shouldAutorotate {
    return [self.delegate shouldAutorotateToOrientation:UIDevice.currentDevice.orientation];
}

/// 支持的选择方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

/// 优先显示的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


/// 当视图控制器view的大小或者窗口旋转时候，会被调用
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    _rotating = YES;
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    /// 当前旋转的设备方向
    UIDeviceOrientation new = UIDevice.currentDevice.orientation;
    /// 上一个设备方向
    UIDeviceOrientation old = _currentOrientation;

    /// 全屏时，将target添加到viewcontroller的view
    if (new == UIDeviceOrientationLandscapeLeft ||
        new == UIDeviceOrientationLandscapeRight ) {
        if (self.delegate.target.superview != self.view) {
            [self.view addSubview:self.delegate.target];
        }
    }
    
    /// 如果以前的方向是竖屏
    /// 先预设target在当前viewcontroller.view上的frame，这样设置全屏的frame会有一个过渡的动画
    if (old == UIDeviceOrientationPortrait) {
        self.delegate.target.frame = self.delegate.targetOriginFrame;
    }
    
    _currentOrientation = new;
    
    /// 开始旋转
    [self.delegate fullScreenModelViewController:self willRotateToOrientation:_currentOrientation];
    
    BOOL isFullScreen = size.width > size.height;
    
    /// 设置更新frame
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (isFullScreen) {
            self.delegate.target.frame = CGRectMake(0, 0, size.width, size.height);
        }
        else{
            self.delegate.target.frame = self.delegate.targetOriginFrame;
        }

        [self.delegate.target layoutIfNeeded];

    } completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        self.rotating = NO;
        [self.delegate fullScreenModelViewController:self didRotateFromOrientation:self.currentOrientation];
    }];
}

/// 是否全屏
- (BOOL)isFullScreen {
    return _currentOrientation == UIDeviceOrientationLandscapeLeft || _currentOrientation == UIDeviceOrientationLandscapeRight;
}

/// 状态栏是否隐藏
- (BOOL)prefersStatusBarHidden {
    return self.delegate.preferStatusBarHidden;
}

/// 状态栏样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.delegate.preferredStatusBarStyle;
}

/// 隐藏刘海屏的底部黑条
- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

@end




#pragma mark - Navigation
@class FullScreenModelNavigationController;
@protocol FullScreenModelNavigationControllerDelegate<NSObject>
- (void)le_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end

@interface FullScreenModelNavigationController : UINavigationController
@property (nonatomic, weak) id<FullScreenModelNavigationControllerDelegate>  le_delegate;
@end


@implementation FullScreenModelNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
}

/// 全屏要隐藏导航栏
- (void)setNavigationBarHidden:(BOOL)navigationBarHidden {
    [super setNavigationBarHidden:YES];
}

- (void)setNavigationBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [super setNavigationBarHidden:YES animated:animated];
}


/// 是否支持自动旋转（传到rootViewController决定）
- (BOOL)shouldAutorotate {
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}


/// 状态栏
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.topViewController;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}


/// push操作
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:FullScreenModeViewController.class]) {
        [super pushViewController:viewController animated:animated];
    }
    else if ([self.le_delegate respondsToSelector:@selector(le_forwardPushViewController:animated:)]) {
        [self.le_delegate le_forwardPushViewController:viewController animated:animated];
    }
}

@end



#pragma mark - UIWindow
@interface FullScreenModelWindow: UIWindow
@property (nonatomic, strong) FullScreenModelNavigationController *rootViewController;
@property (nonatomic, strong) FullScreenModeViewController *fullScreenModelVC;
@end

@implementation FullScreenModelWindow
/// 属性有两个修饰符：@synthesize和@dynamic，默认是@synthesize
/// @synthesize ：编译器会自动加上getter和setter方法 （用法看下方）
/// @dynamic  ：setter和getter方法用户自己是实现
@dynamic rootViewController;


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelNormal;
        self.fullScreenModelVC = FullScreenModeViewController.new;
        self.rootViewController = [[FullScreenModelNavigationController alloc]initWithRootViewController:self.fullScreenModelVC];
        self.hidden = YES;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
        if (@available(iOS 13.0,*)) {
            if (self.windowScene == nil) {
                self.windowScene = UIApplication.sharedApplication.windows[0].windowScene;
            }
        }
#endif
    }
    return self;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}


- (void)setBackgroundColor:(nullable UIColor *)backgroundColor {}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    static CGRect bounds;
    
    /// 这边可以优化，小屏转大屏时，底部有黑色部分
    if (!CGRectEqualToRect(bounds, self.bounds)) {
        UIView *superView = self;
        if (@available(iOS 13.0,*)) {
            superView = self.subviews.firstObject;
        }
        
        [UIView performWithoutAnimation:^{
            for (UIView *view in superView.subviews) {
                if (view != self.rootViewController.view && [view isMemberOfClass:UIView.class]) {
                    view.backgroundColor = UIColor.clearColor;
                    for (UIView *sub in view.subviews) {
                        sub.backgroundColor = UIColor.clearColor;
                    }
                }
            }
        }];
    }
    
    bounds = self.bounds;
    self.rootViewController.view.frame = bounds;
}
@end



#pragma mark - RotationManager
@interface LERotationManager()<FullScreenModelViewControllerDelegate,FullScreenModelNavigationControllerDelegate>
@property (nonatomic, strong) FullScreenModelWindow *window;
@property (nonatomic, weak  ) UIWindow  *previousKeyWindow;

@property (nonatomic, assign,getter=isForcedRotation) BOOL  forcedRotation;
@property (nonatomic, assign,getter=isTransitioning) BOOL  transitioning;
@property (nonatomic, assign) UIDeviceOrientation  deviceOrientation;
@property (nonatomic, assign) LEOrientation  currentOrientation;
@end


@implementation LERotationManager {
    void(^_Nullable _completionHandler)(id<RotationManagerDelegate>mgr);
}

@synthesize autorotationSupportedOrientations = _autorotationSupportedOrientations;
@synthesize shouldTriggerRotation = _shouldTriggerRotation;
@synthesize disbleAutorotation = _disbleAutorotation;
@synthesize superView = _superView;
@synthesize target = _target;


- (instancetype)init {
    self = [super init];
    if (self) {
        _currentOrientation = LEOrientation_Portrait;
        _autorotationSupportedOrientations = LEOrientationMaskAll;
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_window = [FullScreenModelWindow new];
            self->_window.fullScreenModelVC.delegate = self;
            self->_window.rootViewController.le_delegate = self;
            if (@available(iOS 9.0,*)) {
                [self->_window.rootViewController loadViewIfNeeded];
            }
            else{
                [self->_window.rootViewController view];
            }
        });
        
        [self le_addObserveNotifies];
    }
    return self;
}


/// 添加监听
- (void)le_addObserveNotifies {
    UIDevice *device = UIDevice.currentDevice;
    if (!device.isGeneratingDeviceOrientationNotifications) {
        [device beginGeneratingDeviceOrientationNotifications];
    }
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:device];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
}


/// 是否全屏
- (BOOL)isFullScreen {
    return  _currentOrientation == UIDeviceOrientationLandscapeLeft ||
            _currentOrientation == UIDeviceOrientationLandscapeRight;
}


#pragma mark - Action
/// 设备已旋转
/// @param noti noti
- (void)deviceOrientationDidChange:(NSNotification *)noti {
    UIDeviceOrientation orientation = UIDevice.currentDevice.orientation;
    switch (orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            _currentOrientation = orientation;
            break;
            
        default:
            break;
    }
}

/// 设备将进入前台，活跃状态
- (void)willResignActive {
    
}

/// 设备已进入前台
- (void)didBecomeActive {
    
}


#pragma mark - 旋转
/// 旋转
- (void)rotate {
    /// 不支持横屏(这里有待考验，因为都已经不支持横屏了，则不可能转横屏)
    if (![self le_isSupported:LEOrientation_LandscapeLeft] && ![self le_isSupported:LEOrientation_LandscapeRight] ) {
        if (self.isFullScreen) {
            [self rotate:LEOrientation_Portrait animated:YES];
        }else{
            [self rotate:LEOrientation_LandscapeLeft animated:YES];
        }
        return;
    }
    
    /// 全屏转竖屏
    if (self.isFullScreen && [self le_isSupported:LEOrientation_Portrait]) {
        [self rotate:LEOrientation_Portrait animated:YES];
        return;
    }
    
    /// 支持横屏，竖屏转横屏
    if ([self le_isSupported:LEOrientation_LandscapeLeft] || [self le_isSupported:LEOrientation_LandscapeRight]) {
        if (self.window.fullScreenModelVC.currentOrientation == LEOrientation_Portrait) {
            [self rotate:LEOrientation_LandscapeLeft animated:YES];
        }
        return;
    }
    
    /// 只支持横屏 left
    if ([self le_isSupported:LEOrientation_LandscapeLeft] && ![self le_isSupported:LEOrientation_LandscapeRight]) {
        [self rotate:LEOrientation_LandscapeLeft animated:YES];
        return;
    }
    
    /// 只支持横屏 right
    if (![self le_isSupported:LEOrientation_LandscapeLeft] && [self le_isSupported:LEOrientation_LandscapeRight]) {
        [self rotate:LEOrientation_LandscapeRight animated:YES];
        return;
    }
}


- (void)rotate:(LEOrientation)orientation animated:(BOOL)animated {
    [self rotate:orientation animated:animated completionHandler:nil];
}


- (void)rotate:(LEOrientation)orientation animated:(BOOL)animated completionHandler:(void (^)(id<RotationManagerDelegate> _Nullable))completionHandler {
    _completionHandler = completionHandler;
    if (orientation == (NSInteger)self.window.fullScreenModelVC.currentOrientation) {
        [self _finishTransition];
        return;
    }
    
    _forcedRotation = YES;
    _window.fullScreenModelVC.disableAnimations = !animated;
    [UIDevice.currentDevice setValue:@(UIDeviceOrientationUnknown) forKey:@"orientation"];
    [UIDevice.currentDevice setValue:@(orientation) forKey:@"orientation"];
}


#pragma mark - FullScreenModelViewControllerDelegate
- (CGRect)targetOriginFrame {
    if (self.superView.window == nil) {
        return CGRectZero;
    }
    /// convertRect:toView:
    /// 计算self.superView在self.superView.window上的坐标
    /// 等价于下面的另外一种写法
    /// [self.superView.window convertRect:self.superView.bounds fromView:self.superView]
    CGRect rect = [self.superView convertRect:self.superView.bounds toView:self.superView.window];
    NSLog(@"targetOriginFrame: %@",NSStringFromCGRect(rect));
    return rect;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


- (BOOL)preferStatusBarHidden {
    return NO;
}


/// 返回的值用于决定FullScreenModelViewController界面是否要自动旋转
/// @param orientation orientation
- (BOOL)shouldAutorotateToOrientation:(UIDeviceOrientation)orientation {
    /// 如果是加速器旋转，并且是设置禁止自动旋转的，则NO
    if (self.isDisableAutorotation && !_forcedRotation) {
        return NO;
    }
    
    /// 如果要旋转的方向与当前的一致，则 NO
    if (orientation == (NSInteger)_window.fullScreenModelVC.currentOrientation) {
        return NO;
    }
    
    /// 如果当前正在旋转中，则 NO
    if (self.isTransitioning && _window.fullScreenModelVC.isRotating) {
        return NO;
    }
    
    /// 如果是加速器旋转并且是不支持这个方向的则 NO；
    if (!_forcedRotation) {
        if (![self le_isSupported:orientation]) {
            return NO;
        }
    }
    
    /// 更新当前设备的方向
    self.currentOrientation = (NSInteger)orientation;
    
    /// 修改状态值
    if (self.isTransitioning == NO) {
        [self _beginTransition];
    }
    
    /// 如果是转全屏的话，则使self.window显示并为主窗口
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        UIWindow *keyWindow = [self currentKeyWindow];
        if (keyWindow != self.window && self.previousKeyWindow != keyWindow) {
            self.previousKeyWindow = keyWindow;
        }
        if (self.window.isKeyWindow == NO) {
            [self.window makeKeyAndVisible];
        }
    }
    
    return YES;
}


/// FullScreenModelViewController 即将开始旋转
/// @param vc vc
/// @param orientation orientation
- (void)fullScreenModelViewController:(FullScreenModeViewController *)vc willRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        [self performSelector:@selector(_fixNavigationBarLayout) onThread:NSThread.mainThread withObject:@(0) waitUntilDone:NO];
    }
}


/// FullScreenModelViewController 选择完成
/// @param vc vc
/// @param orientation orientation
- (void)fullScreenModelViewController:(FullScreenModeViewController *)vc didRotateFromOrientation:(UIDeviceOrientation)orientation {
    if (!vc.isFullScreen) {
        // 全屏转小屏
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.superView addSubview:self.target];
            UIWindow *previousKeyWindow = self.previousKeyWindow?:UIApplication.sharedApplication.windows[0];
            [previousKeyWindow makeKeyAndVisible];
            self.previousKeyWindow = nil;
            self.window.hidden = YES;
            [self _finishTransition];
        });
    }
    else{
        // 小屏转全屏
        [self _finishTransition];
    }
}



/// 更新UInavigationBar 布局
- (void)_fixNavigationBarLayout {
    UINavigationController *nvc = [self.superView lookupResponderForClass:UINavigationController.class];
    [nvc viewDidAppear:NO];
    [nvc.navigationBar layoutSubviews];
}


#pragma mark - Navigation Delegate
- (void)le_forwardPushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"跳转 le_forwardPushViewController");
}



#pragma mark - help
/// 开始旋转
- (void)_beginTransition {
    self.transitioning = YES;
    if (!_forcedRotation) {
        _window.fullScreenModelVC.disableAnimations = NO;
    }
}

/// 旋转完成（重置状态）
- (void)_finishTransition {
    self.forcedRotation = NO;
    self.transitioning = NO;
    if (_completionHandler) {
        _completionHandler(self);
    }
    _completionHandler = nil;
}


/// 获取keyWindow
- (UIWindow *)currentKeyWindow {
    if (@available(iOS 13.0,*)) {
        return UIApplication.sharedApplication.windows.firstObject;
    }else{
        return UIApplication.sharedApplication.keyWindow;
    }
}

#pragma mark - 判断要旋转的方向是否支持
/// 判断要旋转的方向是否支持
/// @param orientation orientation
- (BOOL)le_isSupported:(LEOrientation)orientation {
    switch (orientation) {
        case LEOrientation_Portrait: {
            return _autorotationSupportedOrientations & LEOrientationMaskPortrait;
        }
            break;
        case LEOrientation_LandscapeLeft: {
            return _autorotationSupportedOrientations & LEOrientationMaskLandscapeLeft;
        }
        case LEOrientation_LandscapeRight: {
            return _autorotationSupportedOrientations & LEOrientationMaskLandscapeRight;
        }
        default:
            break;
    }
    return NO;
}

@end
