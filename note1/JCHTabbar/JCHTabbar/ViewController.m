//
//  ViewController.m
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
    self.view.backgroundColor = [UIColor cyanColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"nav_1_home_active"] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 300, self.view.frame.size.width / 4, 49 * 0.6);
    [self.view addSubview:button];
}




@end
