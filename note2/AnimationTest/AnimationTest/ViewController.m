//
//  ViewController.m
//  AnimationTest
//
//  Created by huangxu on 16/1/20.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "HXSlideMenu.h"

@interface ViewController ()
{
    HXSlideMenu *_slideMenu;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _slideMenu = [[HXSlideMenu alloc] init];
}

- (IBAction)clickAction:(id)sender
{
    [_slideMenu triger];
}


@end
