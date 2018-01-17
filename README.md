# SKDispatcher


用途：跳转工具类
使用说明：
创建一个跳转需要如下几个部分：
Target:工具类方法
`Target_pushTargetVC`
SKDispatcher类目：设置唯一标识找到类
`SKDispatcher+PushTargetVC`
使用：

```
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIViewController *pushTargetVC = [[SKDispatcher sharedInstance]dispatcher_viewControllerPushTargetVC:@{@"pushValue":@"123456"}];
    [self.navigationController pushViewController:pushTargetVC animated:YES];
}
```
传值的时候默认参数为dict

原理：
```
  Class targetClass = NSClassFromString(targetClassString);
    id target = [[targetClass alloc]init];
    SEL action = NSSelectorFromString(actionString);
    if (target == nil) {
        return nil;
    }
    if ([target respondsToSelector:action]) {
        return [target performSelector:action withObject:params];
    }
```
SKDispatcher 属性说明：
```
/**
 appName used for analyse(应用名字，用于统计以及调用)
 */
@property (nonatomic, copy) NSString *appName;
/**
 nativeActionName default is native (本地action调用的方法前缀)optional
 */
@property (nonatomic, copy) NSString *nativeActionName;
/**
 targetClassName default is Target_xxx(默认target类名前缀,默认为Target_)optional
 */
@property (nonatomic, copy) NSString *targetClassName;
/**
 actionMethodName default is action_xxx optional(默认的方法名前缀,默认为action_)optional
 */
@property (nonatomic, copy) NSString *actionMethodName;
```




