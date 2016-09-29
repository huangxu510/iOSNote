//
//  NSMutableArray+MyArray.m
//  RunTime
//
//  Created by huangxu on 16/1/22.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "NSMutableArray+MyArray.h"
#import <objc/runtime.h>

@implementation NSMutableArray (MyArray)


+ (void)load
{
    Class class = NSClassFromString(@"__NSArrayM");
    Method originalMethod = class_getInstanceMethod(class, @selector(objectAtIndex:));
    Method swizzledMethod = class_getInstanceMethod(class, @selector(new_objcAtIndex:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (id)new_objcAtIndex:(NSUInteger)index
{
    if (self.count <= index) {
    
        NSLog(@"index beyond bounds----- %@", self.class);
        return nil;
        
    } else {
        return [self new_objcAtIndex:index];
    }
}

@end
