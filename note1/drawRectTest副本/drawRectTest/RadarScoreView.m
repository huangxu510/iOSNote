//
//  RadarScoreView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/20.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "RadarScoreView.h"

@implementation RadarScoreView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat radius = self.bounds.size.height * 1.5 / (sqrt(3) + 2);
    CGFloat centerX = self.bounds.size.width / 2;
    CGFloat centerY = self.bounds.size.height * 2 / (sqrt(3) + 2);
    
    NSInteger numOfAngle = 5;
    CGFloat radPerV = M_PI * 2 / numOfAngle;
    
    
    NSArray *scores = @[@"4", @"4.5", @"4.1", @"3.5", @"4.5"];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [RGBColor(98, 173, 255, 0.7) set];
    CGContextMoveToPoint(ctx, centerX, centerY - radius * ([scores[0] doubleValue] / 5));
    for (int i = 1; i <= 4; ++i)
    {
        CGContextAddLineToPoint(ctx,
                                centerX - radius * sin(i * radPerV) * ([scores[i] doubleValue] / 5),
                                centerY - radius * cos(i * radPerV) * ([scores[i] doubleValue] / 5)) ;
    }
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    
    [RGBColor(92, 165, 247, 1) set];
    
    //边缘线
    CGContextMoveToPoint(ctx, centerX, centerY - radius * ([scores[0] doubleValue] / 5));
    for (int i = 1; i <= 4; ++i)
    {
        CGContextAddLineToPoint(ctx,
                                centerX - radius * sin(i * radPerV) * ([scores[i] doubleValue] / 5),
                                centerY - radius * cos(i * radPerV) * ([scores[i] doubleValue] / 5)) ;
    }
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
    
    //边缘球
    for (NSInteger i = 0; i < 5; i++) {
        CGPoint point = CGPointMake(centerX - radius * sin(i * radPerV) * ([scores[i] doubleValue] / 5),
                                    centerY - radius * cos(i * radPerV) * ([scores[i] doubleValue] / 5));
        CGContextAddArc(ctx, point.x, point.y, 4, 0, M_PI * 2, 1);
        CGContextFillPath(ctx);
    }
    
    //球边缘
    for (NSInteger i = 0; i < 5; i++) {
        [[UIColor whiteColor] set];
        CGPoint point = CGPointMake(centerX - radius * sin(i * radPerV) * ([scores[i] doubleValue] / 5),
                                    centerY - radius * cos(i * radPerV) * ([scores[i] doubleValue] / 5));
        CGContextAddArc(ctx, point.x, point.y, 4, 0, M_PI * 2, 1);
        CGContextStrokePath(ctx);
    }
}


@end
