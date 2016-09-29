//
//  ForthViewController.m
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ForthViewController.h"

@implementation ForthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.title = @"我的";
    self.view.backgroundColor = [UIColor redColor];
}


@end
