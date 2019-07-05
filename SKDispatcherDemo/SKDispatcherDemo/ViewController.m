//
//  ViewController.m
//  SKDispatcherDemo
//
//  Created by shavekevin on 2018/1/16.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "ViewController.h"
#import "SKDispatcher+PushTargetVC.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    // 1.跳转方式1
    UIViewController *pushTargetVC = [[SKDispatcher sharedInstance]dispatcher_viewControllerPushTargetVC:@{@"pushValue":@"123456"}];
    [self.navigationController pushViewController:pushTargetVC animated:YES];
    return;
    // 2.跳转方式2
    UIViewController *pushTargetVC2 = [[SKDispatcher sharedInstance] dispatcher_viewControllerForTargetDict:@{@"Target":@"pushTargetVC",@"Action":@"nativePushTargetVC"} params:@{@"pushValue":@"666666"}];
    [self.navigationController pushViewController:pushTargetVC2 animated:YES];

    
}


@end
