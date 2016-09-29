//
//  MyView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/14.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MyLineView.h"

@implementation MyLineView


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置一个起点
    CGContextMoveToPoint(ctx, 10, 10);
    
    CGContextSetLineWidth(ctx, 10);
    
    // 设置线段头尾样式
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //设置线段转折点样式
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    //添加一条线段
    CGContextAddLineToPoint(ctx, 100, 100);
    CGContextAddLineToPoint(ctx, 150, 40);
    CGContextSetRGBStrokeColor(ctx, 1, 0, 0, 1);
    //渲染到view
    CGContextStrokePath(ctx);
    
    
    CGContextMoveToPoint(ctx, 20, 30);
    CGContextAddLineToPoint(ctx, 100, 200);
    
    
    CGContextSetRGBStrokeColor(ctx, 0, 0, 1, 1);
    
    //渲染到view
    CGContextStrokePath(ctx);
    
}

@end
