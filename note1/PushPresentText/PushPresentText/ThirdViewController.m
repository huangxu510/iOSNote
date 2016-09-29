//
//  ThirdViewController.m
//  PushPresentText
//
//  Created by huangxu on 15/12/31.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ThirdViewController.h"

@implementation ThirdViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor brownColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:YES];
}

@end
