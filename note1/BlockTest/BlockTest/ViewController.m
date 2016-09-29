//
//  ViewController.m
//  BlockTest
//
//  Created by huangxu on 16/1/13.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

typedef int(^MyBlock)();
@interface ViewController ()

@property (copy) MyBlock block;
@end

@implementation ViewController

- (void)dealloc
{
    //[self.block release];
    //[super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
#if __has_feature(objc_arc)
    NSLog(@"----------ARC---------");
#else
    NSLog(@"----------MRC---------");
#endif
    
    [self test2];
    test3();
}
//
/**
 *  对于没有引用外部变量的Block，无论在ARC还是非ARC下，类型都是__NSGlobalBlock__，这种类型的block可以理解成一种全局的block，不需要考虑作用域问题。同时，对他进行copy或者retain操作也是无效的
 */
- (void)test1
{
    MyBlock block = func();
    NSLog(@"%d", block());
    NSLog(@"%@", [block class]);
    MyBlock block2 = [block copy];
    NSLog(@"%d", block == block2);
}

MyBlock func()
{
    return ^{return 123;};
}


/**
 *  对于引用了外部变量的Block，如果没有对他进行copy，他的作用域只会在声明他的函数栈内（类型是__NSStackBlock__），如果想在非ARC下直接返回此类Block，Xcode会提示编译错误的
 */
- (void)test2
{
    MyBlock block = func();
    NSLog(@"%d", block());
    NSLog(@"%@", [block class]);
}

MyBlock func2()
{
    int i = 123;
    return [^{return i;} copy];
}


/**
 *  Block被copy后，他所引用的变量被复制到了堆中
    在Block执行中，他所引用的变量a和b都被复制到了堆上。而被标记__block的变量事实上应该说是被移动到了堆上，因此，当Block执行后，函数栈内访问b的地址会变成堆中的地址。而变量a，仍会指向函数栈内原有的变量a的空间
 */
void test3()
{
    int a = 123;
    __block int b = 123;
    NSLog(@"%@", @"---------- block copy前");
    NSLog(@"&a = %p, &b = %p", &a, &b);
    
    void(^block)() = ^{
        NSLog(@"%@", @"---------- Block");
        NSLog(@"&a = %p, &b = %p", &a, &b);
        NSLog(@"a = %d, b = %d", a, b = 456);
    };
    
    //copy会把block从栈上移动到堆上
    NSLog(@"----------copy前");
    block();
    block = [block copy];
    NSLog(@"----------copy后");
    block();
    
    NSLog(@"%@", @"---------- block copy后");
    NSLog(@"&a = %p, &b = %p", &a, &b);
    NSLog(@"a = %d, b = %d", a, b);
    
    //[block release];
}

@end
