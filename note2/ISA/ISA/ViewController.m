//
//  ViewController.m
//  ISA
//
//  Created by huangxu on 16/1/22.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "Child.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Child *child = [[Child alloc] init];
    NSLog(@"%@", child);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
