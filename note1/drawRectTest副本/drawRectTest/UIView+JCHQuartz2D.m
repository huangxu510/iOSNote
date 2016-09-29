//
//  UIView+JCHQuartz2D.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "UIView+JCHQuartz2D.h"

@implementation UIView (JCHQuartz2D)

- (void)drawRectangle:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddRect(ctx, rect);
    CGContextFillPath(ctx);
}

- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(ctx, endPoint.x, endPoint.y);
    
    CGContextStrokePath(ctx);
}

@end
