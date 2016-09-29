//
//  ViewController.m
//  NSSet
//
//  Created by huangxu on 16/1/28.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *arr1 = @[@"08FE4334-BDB9-11E5-B657-985AEBE33272", @"1160DD2A-BDB9-11E5-B657-985AEBE33272", @"3", @"4"];
    NSArray *arr2 = @[@"08FE4334-BDB9-11E5-B657-985AEBE33272", @"1160DD2A-BDB9-11E5-B657-985AEBE33272"];
    
    NSSet *set1 = [NSSet setWithArray:arr1];
    NSSet *set2 = [NSSet setWithArray:arr2];
    
    if ([set2 isSubsetOfSet:set1]) {
        NSLog(@"yes");
    } else {
        NSLog(@"no");
    }
    
}


@end
