# LERotationManager
[完整文章]()

### 轻松实现横竖屏切换



<video src="/Users/yyk/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/4d94dd3970868f14a28205aca5c6f2f1/Message/MessageTemp/9f2bf113e5e4df43a5f76c9e4d2eba25/Video/1592207052806870.mp4"></video>



**使用方法**

（1）将LERotationManager拉入项目中

<img src="https://i.loli.net/2020/06/15/xQy56CY97nkU2KW.png" alt="image-20200615154701929" style="zoom: 33%;" />

（2）设置支持旋转的方向

![image-20200615154829260](https://i.loli.net/2020/06/15/zZHMk9NCfsyW2Ar.png)



或者在AppDelegate中设置（两个方法，选择其一就行）

```objc
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
```

（3）创建RotationManager对象，并设置将要旋转的UIView

<img src="https://i.loli.net/2020/06/15/5DNuWIQPvgAVaUB.png" alt="image-20200615155142138" style="zoom:50%;" />

（4）触发rotate方法，实现横竖屏切换