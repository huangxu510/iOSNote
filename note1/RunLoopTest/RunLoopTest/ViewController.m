//
//  ViewController.m
//  RunLoopTest
//
//  Created by huangxu on 15/11/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "MyView.h"
#import "MyViewController.h"

@interface ViewController ()

@property(nonatomic, retain) Person *p;

@end

@implementation ViewController

- (void)dealloc
{
    [self.p release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    MyView *view = [[[MyView alloc] init] autorelease];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(0, 0, 100, 200);
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 300, 300, 100);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    NSLog(@"over");
}

- (void)action
{
    MyViewController *vc = [[[MyViewController alloc] init] autorelease];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)action2
{
    NSLog(@"xxx");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
