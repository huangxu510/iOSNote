//
//  Person.m
//  RunTime
//
//  Created by huangxu on 16/1/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>

//动态添加方法
@implementation Person

// 默认方法都有两个隐式参数
void eat(id self,SEL sel)
{
    NSLog(@"%@, %@", self, NSStringFromSelector(sel));
}


// 动态添加eat方法
// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    if (sel == @selector(eat)) {
        
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void      @:对象->self     :表示SEL->_cmd
        // int say(id self, SEL _cmd, NSString *str)  ->  "i@:@"
        class_addMethod(self, @selector(eat), (IMP)eat, "v@:");
    }
    
    return [super resolveInstanceMethod:sel];
}


@end
