//
//  UIImage+MyImage.m
//  RunTime
//
//  Created by huangxu on 16/1/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "UIImage+MyImage.h"
//#import <objc/message.h>
#import <objc/runtime.h>

static const char *key = "name";
@implementation UIImage (MyImage)

//动态交换方法
//加载分类到内存的时候调用
+ (void)load
{
    // 通过class_getInstanceMethod()函数从当前对象中的method list获取method结构体，如果是类方法就使用class_getClassMethod()函数获取
    //获取imageWithName方法地址
    Method imageWithName = class_getClassMethod(self, @selector(imageWithName:));
    
    //获取imageName方法地址
    Method imageName = class_getClassMethod(self, @selector(imageNamed:));

    //交换方法地址
    method_exchangeImplementations(imageName, imageWithName);
    
#if 0
    /**
     *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
     *  而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
     *  所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
     */

    BOOL success = class_addMethod([self class], @selector(imageNamed:), method_getImplementation(imageWithName), method_getTypeEncoding(imageWithName));
    if (success) {
        class_replaceMethod([self class], @selector(imageWithName:), method_getImplementation(imageName), method_getTypeEncoding(imageName));
    } else {
        method_exchangeImplementations(imageName, imageWithName);
    }
#endif
}

+ (instancetype)imageWithName:(NSString *)name
{
    UIImage *image = [self imageWithName:name];
    
    if (image == nil) {
        NSLog(@"加载空的图片");
    }
    return image;
}





#if 1
//给分类添加属性
- (NSString *)name
{
    //根据关联的key，获取关联的值
    return objc_getAssociatedObject(self, key);
    
    //_cmd在Objective-C的方法中表示当前方法的selector，正如同self表示当前方法调用的对象实例
    //return objc_getAssociatedObject(self, _cmd);
}

- (void)setName:(NSString *)name
{
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#endif

@end
