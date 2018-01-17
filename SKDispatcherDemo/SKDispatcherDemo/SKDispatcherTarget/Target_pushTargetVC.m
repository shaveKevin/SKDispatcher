//
//  Target_pushTargetVC.m
//  SKDispatcherDemo
//
//  Created by shavekevin on 2018/1/17.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "Target_pushTargetVC.h"
#import "TargetVC.h"
@implementation Target_pushTargetVC

- (UIViewController *)action_nativePushTargetVC:(NSDictionary *)params {
    
    TargetVC *testPushFIleVC = [[TargetVC alloc]init];
    testPushFIleVC.pushValue = params[@"pushValue"];
    return testPushFIleVC;
}

@end
