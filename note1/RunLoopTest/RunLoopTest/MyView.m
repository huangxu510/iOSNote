//
//  MyView.m
//  RunLoopTest
//
//  Created by huangxu on 15/11/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MyView.h"

@implementation MyView


- (void)dealloc
{
    
    NSLog(@"view %ld", self.i);
    
    [super dealloc];
}


@end
