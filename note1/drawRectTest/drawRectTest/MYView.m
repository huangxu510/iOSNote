//
//  MYView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MYView.h"

@implementation MYView

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //将ctx拷贝一份放到栈中
    CGContextSaveGState(ctx);
    
    [[UIColor redColor] set];
    CGContextSetLineWidth(ctx, 10);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    //第一根线
    CGContextMoveToPoint(ctx, 50, 50);
    CGContextAddLineToPoint(ctx, 100, 200);
    CGContextStrokePath(ctx);
    
    //将栈顶的上下文出栈,替换当前的上下文
    CGContextRestoreGState(ctx);
    //第二根线
    CGContextMoveToPoint(ctx, 200, 50);
    CGContextAddLineToPoint(ctx, 200, 300);

    CGContextStrokePath(ctx);
//    CGContextDrawPath(ctx, kCGPathStroke);
    
}

@end
