//
//  SecondViewController.m
//  AFNetWorking
//
//  Created by huangxu on 16/1/15.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "SecondViewController.h"
#import "AFNetworking.h"

@interface SecondViewController ()

@end

@implementation SecondViewController


- (void)dealloc
{
    NSLog(@"dealloc");
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
    //网络连接情况判断
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //启动网络状态监听
    [manager startMonitoring];
    
    __block typeof(self) weakSelf = self;
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"网络发送变化");
        
        if (status == AFNetworkReachabilityStatusNotReachable)
        {
            NSLog(@"没有网络");
            //无网络
        }
        else
        {
            NSLog(@"有网络");
            //有网络
            [weakSelf test];
            [manager stopMonitoring];
        }
    }];
    
    
}

- (void)test
{
    
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
