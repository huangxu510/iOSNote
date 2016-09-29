//
//  ViewController.m
//  Timer
//
//  Created by huangxu on 16/1/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    dispatch_source_t _timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self displayLink];
    [self GCDTimer];
}


- (void)GCDTimer
{
#if 0
    //执行一次
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self timerAction];
    });
#endif
    
    //重复执行  timer一定要设置为全局变量
    CGFloat period = 1.0;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, period * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        [self timerAction];
    });
    dispatch_resume(_timer);
}

/**
 frameInterval
 NSInteger类型的值，用来设置间隔多少帧调用一次selector方法，默认值是1，即每帧都调用一次。
 
 duration
 readOnly的CFTimeInterval值，表示两次屏幕刷新之间的时间间隔。需要注意的是，该属性在target的selector被首次调用以后才会被赋值。selector的调用间隔时间计算方式是：调用间隔时间 = duration × frameInterval。
 */

- (void)displayLink
{
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(timerAction)];
    displayLink.frameInterval = 60;
    
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)timerAction
{
    static NSInteger i = 0;
    NSLog(@"i = %ld", i++);
}

@end
