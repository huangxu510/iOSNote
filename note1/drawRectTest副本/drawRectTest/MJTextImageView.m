//
//  MJTextImageView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "MJTextImageView.h"

@implementation MJTextImageView

- (void)drawRect:(CGRect)rect
{
    drawImage();
}

void drawImage()
{
    UIImage *image = [UIImage imageNamed:@"icon-2"];
    [image drawAtPoint:CGPointMake(50, 50)];
//    [image drawInRect:CGRectMake(0, 0, 100, 100)];
//    [image drawAsPatternInRect:CGRectMake(0, 0, 200, 200)];
    
    NSString *str = @"买卖人科技";
    [str drawInRect:CGRectMake(0, 180, 100, 30) withAttributes:nil];
}


void drawText()
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    CGRect cubeRect = CGRectMake(50, 50, 100, 100);
    CGContextAddRect(ctx, cubeRect);
    CGContextFillPath(ctx);    //实心

    //画文字
    NSString *str = @"qwert键盘，买卖人科技";
    //    [str drawAtPoint:CGPointZero withAttributes:nil];
    NSDictionary *attrs = @{NSForegroundColorAttributeName : [UIColor redColor]};
    [str drawInRect:cubeRect withAttributes:attrs];
}

@end
