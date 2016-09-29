//
//  ViewController.m
//  AFNetWorking
//
//  Created by huangxu on 16/1/15.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "SecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextVC:(id)sender
{
    SecondViewController *second = [[[SecondViewController alloc] init] autorelease];
    [self.navigationController pushViewController:second animated:YES];
}

@end
