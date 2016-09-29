//
//  MyViewController.m
//  RunLoopTest
//
//  Created by huangxu on 15/11/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MyViewController.h"
#import "MyView.h"

@implementation MyViewController

- (void)viewDidLoad
{
    
    MyView *view = [[[MyView alloc] init] autorelease];
    view.backgroundColor = [UIColor redColor];
    view.frame = CGRectMake(0, 0, 100, 200);
    [self.view addSubview:view];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, 300, 300, 100);
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    
    NSLog(@"myviewcontroller dealloc");
    [super dealloc];
}
@end
