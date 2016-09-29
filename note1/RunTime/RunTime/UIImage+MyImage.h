//
//  UIImage+MyImage.h
//  RunTime
//
//  Created by huangxu on 16/1/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MyImage)

@property (nonatomic, copy) NSString *name;
+ (instancetype)imageWithName:(NSString *)name;

@end
