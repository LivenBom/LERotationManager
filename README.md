# LERotationManager
[完整文章](https://callliven.github.io/2020/06/12/横屏竖屏，不再难/)

-----2020年06月16日 更新

勘误：项目info.plist的横竖屏必须设置成只支持竖屏的，而appdelegate设置支持横竖屏，避免在没锁屏时，在手机设备横屏的时候，打开app导致只支持竖屏的页面，变成横屏，详情请到[完整文章](https://callliven.github.io/2020/06/12/横屏竖屏，不再难/)查阅



```-------------------------------------- 我是分割线 --------------------------------------```



### 轻松实现横竖屏切换



<video src="/Users/yyk/Library/Containers/com.tencent.xinWeChat/Data/Library/Application Support/com.tencent.xinWeChat/2.0b4.0.9/4d94dd3970868f14a28205aca5c6f2f1/Message/MessageTemp/9f2bf113e5e4df43a5f76c9e4d2eba25/Video/1592207052806870.mp4"></video>



**使用方法**

（1）将LERotationManager添加到项目中

<img src="https://i.loli.net/2020/06/15/xQy56CY97nkU2KW.png" alt="image-20200615154701929" style="zoom: 33%;" />



（2）设置支持旋转的方向(勘误修正后)

第一：在info.plist文件或者General中设置成只支持竖屏

![image-20200616171924199](https://i.loli.net/2020/06/16/nIGcHEyWlOLKszQ.png)



第二：在AppDelegate中设置同时支持横竖屏

```objc
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
```



（3）创建RotationManager对象，并设置将要旋转的UIView

<img src="https://i.loli.net/2020/06/15/5DNuWIQPvgAVaUB.png" alt="image-20200615155142138" style="zoom:50%;" />

（4）触发rotate方法，实现横竖屏切换