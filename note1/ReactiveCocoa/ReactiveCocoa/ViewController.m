//
//  ViewController.m
//  ReactiveCocoa
//
//  Created by huangxu on 15/9/28.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import <ReactiveCocoa.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

//    [self createRACReplaySubject];
}

- (void)createRACReplaySubject
{
    //RACReplaySubject,重复提供信号者，RACSubject的子类,如果一个信号每被订阅一次，就需要把之前的值重复发送一遍，使用重复提供信号类
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
}

- (void)createRACSubject
{
    //RACSubject:信号提供者，自己可以充当信号，又能发送信号,通常用来代替代理，有了它，就不必要定义代理了
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id x) {
        NSLog(@"第一个订阅者%@", x);
    }];
    [subject subscribeNext:^(id x) {
        NSLog(@"第二个订阅者%@", x);
    }];
    
    [subject sendNext:@"111"];
    [subject sendNext:@"222"];
}

- (void)createSignal
{
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // block调用时刻：每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@1];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [signal subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
}

- (void)observeSignal
{
    [self.usernameTextField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
    
    [[self.usernameTextField.rac_textSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }]
     subscribeNext:^(id x) {
         NSLog(@"x = %@", x);
     }];
}

- (void)filterSignal
{
    RACSignal *usernameSourceSignal = self.usernameTextField.rac_textSignal;
    RACSignal *fileredUsername = [usernameSourceSignal filter:^BOOL(id value) {
        NSString *text = value;
        return text.length > 3;
    }];
    
    [fileredUsername subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.usernameTextField endEditing:YES];
}

//跳转之前进行处理
//该函数一般用来处理控制器之间的参数传递
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SecondViewController *secondVC = segue.destinationViewController;
    secondVC.delegateSignal = [RACSubject subject];
    [secondVC.delegateSignal subscribeNext:^(id x) {
        NSLog(@"第一个页面点击了通知按钮%@", x);
    }];
}

@end



