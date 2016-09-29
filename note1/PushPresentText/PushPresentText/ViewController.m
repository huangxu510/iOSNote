//
//  ViewController.m
//  PushPresentText
//
//  Created by huangxu on 15/12/31.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"首页";
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(100, 200, 100, 100);
    [nextButton setTitle:@"下一页" forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //self.navigationController.navigationBar.hidden = NO;
}

- (void)nextVC
{
    NSLog(@"firstVC = %@", self);
    NSLog(@"self.Nav = %@", self.navigationController);
    SecondViewController *secondVC = [[SecondViewController alloc] init];
    //[self presentViewController:secondVC animated:YES completion:^{
        //NSLog(@"secondeVC.presentingVC = %@", secondVC.presentingViewController);
    //}];
    
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
