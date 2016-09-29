//
//  ViewController.m
//  RunTime
//
//  Created by huangxu on 16/1/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h>
#import "UIImage+MyImage.h"



@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIImage *image = [UIImage imageNamed:@"123"];
    
    //Person *p = [[Person alloc] init];
    
    
    //[p performSelector:@selector(eat)];
    
    //UIImage *image = [[UIImage alloc] init];
    //image.name = @"123";
    
    //NSLog(@"name = %@", image.name);
    
    NSArray *testArr = @[@"123", @"456", @"789"];
    NSMutableArray *testMutableArr = [NSMutableArray arrayWithArray:testArr];
    NSLog(@"%@", [testMutableArr objectAtIndex:3]);
}



@end
