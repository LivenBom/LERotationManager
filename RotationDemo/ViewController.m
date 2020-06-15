//
//  ViewController.m
//  RotationDemo
//
//  Created by Liven on 2020/6/11.
//  Copyright © 2020 Liven. All rights reserved.
//

#import "ViewController.h"
#import "LERotationManager.h"

/**
 有两个问题要解决：
 1. 重写全部UIViewControllerde shouldAutorotate方法，设置默认值是NO
    如果使用继承的方式，要改动的地方比较多，除非，原项目中，就有一个继承于UIViewController的类(可以框架中的UIIViewController+LERotation删除)；
    基于shouldAutorotate在项目中，除了有要旋转的功能，基本是不使用的，所以使用分类的方式对于项目来说是友好的
 2.rotationManager 中的superView 和 target 只保留一个，化简
 */

@interface ViewController ()
@property (nonatomic, strong, readwrite) UIView *mineContainView;
@property (nonatomic, strong, readwrite) UIView *playerView;
@property (nonatomic, strong) LERotationManager *rotationManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 要旋转的UIView
    self.playerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
    self.playerView.backgroundColor = [UIColor redColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreen)];
    [self.playerView addGestureRecognizer:tap];
    [self.view addSubview:self.playerView];
    
    // 创建rotationManager对象
    self.rotationManager = [[LERotationManager alloc]init];
    // 设置要旋转的UIView
    self.rotationManager.target = self.playerView;
}

- (void)fullScreen {
    // 调用旋转方法
    [self.rotationManager rotate];
}


@end
