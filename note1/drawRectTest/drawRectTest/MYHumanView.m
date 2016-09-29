//
//  MYHumanView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MYHumanView.h"

@implementation MYHumanView

- (void)drawRect:(CGRect)rect
{
    //1.上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
//    drawBody(ctx, rect);
    drawMouse(ctx, rect);
    
    CGContextStrokePath(ctx);
}

void drawMouse(CGContextRef ctx, CGRect rect)
{
    //控制点
    CGFloat controlX = rect.size.width * 0.5;
    CGFloat controlY = rect.size.width * 0.5;
    
    //当前点
    CGFloat marginX = 30;
    CGFloat marginY = 15;
    CGFloat currentX = controlX - marginX;
    CGFloat currentY = controlY - marginY;
    
    CGContextMoveToPoint(ctx, currentX, currentY);
    
    //结束点
    CGFloat endX = controlX + marginX;
    CGFloat endY = currentY;
    
    //贝塞尔曲线
    CGContextAddQuadCurveToPoint(ctx, controlX, controlY, endX, endY);
}

void drawBody(CGContextRef ctx, CGRect rect)
{
    //2.身体
    //  上半圆
    CGFloat topX = rect.size.width * 0.5;
    CGFloat topY = 100;
    CGFloat topRadius = 50;
    CGContextAddArc(ctx, topX, topY, topRadius, 0, M_PI, 1);
    
    //向下延伸
    CGFloat middleX = topX - topRadius;
    CGFloat middleH = 100;
    CGFloat middleY = topY + middleH;
    CGContextAddLineToPoint(ctx, middleX, middleY);
}

@end
