//
//  MyShapeView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/14.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MyShapeView.h"

@implementation MyShapeView

- (void)drawRect:(CGRect)rect
{
    draw4Rect();
}

//画四边形
void draw4Rect()
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddRect(ctx, CGRectMake(10, 10, 100, 100));
    
//    CGContextStrokePath(ctx); //空心
    CGContextFillPath(ctx);     //实心
}

//三角形
void drawTrangle()
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //画三角形
    CGContextMoveToPoint(ctx, 0, 0);
    
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 150, 80);
    
    // set : 同时设置为实心和空心颜色
    // setStroke : 设置空心颜色
    // setFill : 设置实心颜色
    [[UIColor blueColor] set];
    
    //关闭路径
    CGContextClosePath(ctx);
    
    CGContextStrokePath(ctx);
}

@end
