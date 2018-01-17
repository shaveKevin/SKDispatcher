//
//  TargetVC.m
//  SKDispatcherDemo
//
//  Created by shavekevin on 2018/1/17.
//  Copyright © 2018年 shavekevin. All rights reserved.
//

#import "TargetVC.h"

@interface TargetVC ()

@end

@implementation TargetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    NSLog(@"self.pushValue is --->>>>>%@",self.pushValue);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
