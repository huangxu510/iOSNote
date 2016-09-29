//
//  SecondViewController.m
//  PushPresentText
//
//  Created by huangxu on 15/12/31.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"

@implementation SecondViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //self.fd_prefersNavigationBarHidden = YES;
    //self.fd_interactivePopDisabled = YES;

    self.title = @"第二页";
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(100, 200, 100, 100);
    [nextButton setTitle:@"下一页..." forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {//push

    } else if ([viewControllers indexOfObject:self] == NSNotFound) {//pop
      
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
}


- (void)nextVC
{
    NSLog(@"self.presentingVC = %@", self.presentingViewController);
    UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    NSLog(@"firstVC = %@", nav.viewControllers);
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [self.navigationController pushViewController:third animated:YES];
}

@end
