//
//  HXViewController.m
//  StaticTest
//
//  Created by huangxu on 16/5/17.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "HXViewController.h"

@interface HXViewController ()

@end

// static修饰的变量在编译时就会分配内存（静态存储区）
static NSInteger i = 0;

@implementation HXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"i = %ld", i);
    i++;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
