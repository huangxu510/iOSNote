//
//  ViewController.m
//  GCDTest
//
//  Created by huangxu on 15/12/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test3];
}
- (void)test1
{
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"--------%ld--------", i);
        });
    }
    
    //顺序输出
}

- (void)test2
{
    for (NSInteger i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"--------%ld--------", i);
        });
    }
    //不一定顺序输出
}

- (void)test3
{
    NSLog(@"1");
    
    for (NSInteger i = 0; i < 9; i++)
    {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSLog(@"2");
            sleep(5);
            NSLog(@"3");
        });
    }
    
    
    NSLog(@"4");
    
    //同步提交, 输出结果按顺序，会阻塞线程
}

- (void)test4
{
    NSLog(@"1");
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"2");
        sleep(5);
        NSLog(@"3");
    });
    
    NSLog(@"4");
    
    //异步提交, 输出结果无序, 不会阻塞线程
}


@end
