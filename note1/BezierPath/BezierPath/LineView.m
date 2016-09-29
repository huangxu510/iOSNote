//
//  LineView.m
//  BezierPath
//
//  Created by huangxu on 16/1/15.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "LineView.h"

@implementation LineView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 5;
    [[UIColor redColor] set];
    [bezierPath moveToPoint:CGPointMake(100, 100)];
    [bezierPath addLineToPoint:CGPointMake(200, 100)];
    [bezierPath stroke];
}


@end
