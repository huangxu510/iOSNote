//
//  MyCircleView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/14.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MyCircleView.h"

@implementation MyCircleView


/**
 *  第一次显示时调用
 */
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画圆弧  clockwise伸展方向 0顺时针 1逆时针
    CGContextAddArc(ctx, 100, 100, 50, 0, M_PI, 1);
    
    CGContextStrokePath(ctx);     //实心
}

void drawCiecle()
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(ctx, 10);
    [[UIColor cyanColor] set];
    
    CGContextAddEllipseInRect(ctx, CGRectMake(50, 10, 200, 200));
    
    //    CGContextStrokePath(ctx); //空心
    CGContextStrokePath(ctx);     //实心
}


@end
