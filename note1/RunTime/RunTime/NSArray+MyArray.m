//
//  NSArray+MyArray.m
//  RunTime
//
//  Created by huangxu on 16/1/22.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "NSArray+MyArray.h"
#import <objc/runtime.h>

@implementation NSArray (MyArray)

/*
    iOS黑魔法－Method Swizzling
    http://www.cocoachina.com/ios/20160121/15076.html
    http://itony.me/592.htmlQQ
    
    swizzling类库
    https://github.com/rentzsch/jrswizzle
 */
+ (void)load
{
    //Class class = [self class];
    Class class = NSClassFromString(@"__NSArrayI");
    Method originalMethod = class_getInstanceMethod(class, @selector(objectAtIndex:));
    Method swizzledMethod = class_getInstanceMethod(class, @selector(new_objcAtIndex:));
    
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (id)new_objcAtIndex:(NSUInteger)index
{
    if (self.count <= index) {
        //// 这里做一下异常处理
        //@try {
            //return [self new_objcAtIndex:index];
        //}
        //@catch (NSException *exception) {
            //// 在崩溃后会打印崩溃信息，方便我们调试。
            //NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            //NSLog(@"%@", [exception callStackSymbols]);
        //}
        //@finally {
            
        //}
        NSLog(@"index beyond bounds----%@", self.class);
        return nil;
       
    } else {
        return [self new_objcAtIndex:index];
    }
}

@end
