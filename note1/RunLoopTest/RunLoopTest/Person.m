//
//  Person.m
//  RunLoopTest
//
//  Created by huangxu on 15/11/4.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "Person.h"

@implementation Person

- (void)dealloc
{
    [self.name release];
    
    
    NSLog(@"person %ld", self.i);
    
    [super dealloc];
}

@end
