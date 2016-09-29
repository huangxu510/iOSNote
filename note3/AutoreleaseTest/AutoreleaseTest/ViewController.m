//
//  ViewController.m
//  AutoreleaseTest
//
//  Created by huangxu on 16/9/23.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (IBAction)createData:(id)sender {
    
    for (NSInteger i = 0; i < 1000000; i++) {
        UIView *view = [[[UIView alloc] init] autorelease];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
