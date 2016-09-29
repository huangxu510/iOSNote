//
//  ViewController.m
//  BezierPath
//
//  Created by huangxu on 16/1/15.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "LineView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LineView *line = [[LineView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:line];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
