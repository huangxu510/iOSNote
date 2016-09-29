//
//  ViewController.m
//  UserDefault
//
//  Created by huangxu on 16/8/10.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"qqq", @"www"]];
    [userDefault setObject:array forKey:@"array"];
    
    NSMutableArray *arr = [userDefault objectForKey:@"array"];
    [arr addObject:@"eee"];
    [userDefault setObject:arr forKey:@"array"];
    
    NSArray *arr2 = [userDefault objectForKey:@"array"];
    NSLog(@"arr2 = %@", arr2);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
