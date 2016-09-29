//
//  SecondViewController.m
//  ReactiveCocoa
//
//  Created by huangxu on 15/10/8.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "SecondViewController.h"

@implementation SecondViewController

- (IBAction)notice:(id)sender
{
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:@"qwert"];
    }
}
@end
