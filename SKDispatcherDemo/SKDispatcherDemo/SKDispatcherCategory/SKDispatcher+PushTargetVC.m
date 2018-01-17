//
//  SKDispatcher+PushTargetVC.m
//  SKDispatcherDemo
//
//  Created by shavekevin on 2018/1/17.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "SKDispatcher+PushTargetVC.h"
//Target name
NSString * const kDispatcherTargetPushTarget = @"pushTargetVC";
//Action name
NSString * const kDispatcherActionNativePushTargetVC = @"nativePushTargetVC";
@implementation SKDispatcher (PushTargetVC)

- (UIViewController *)dispatcher_viewControllerPushTargetVC:(NSDictionary *)params {
    //1.创建ViewController
    UIViewController *viewController = [self performTarget:kDispatcherTargetPushTarget
                                                    action:kDispatcherActionNativePushTargetVC
                                                    params:params];
    //2.交付view controller，由外界选择是push还是present
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
        
    } else {
        return [[UIViewController alloc] init];
    }
}

@end
