//
//  RadarView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/19.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "RadarView.h"
#import "BezierPathView.h"
#import "RadarScoreView.h"

@interface RadarView ()
{
    CGPoint _centerPoint;
    RadarScoreView *_scoreView;
    UILabel *_scoreLabel;
}
@end

@implementation RadarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    [_scoreLabel removeFromSuperview];
    [_scoreView removeFromSuperview];
    
    CGFloat radius = self.frame.size.height * 1.5 / (sqrt(3) + 2);
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height * 2 / (sqrt(3) + 2);
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    NSInteger numOfAngle = 5;
    CGFloat radPerV = M_PI * 2 / numOfAngle;
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw steps line
    CGContextSaveGState(context);
    for (int step = 5; step > 0; step--) {
        
        //第一个for循环划线
        for (int i = 0; i <= numOfAngle; ++i) {
            if (i == 0) {
                CGContextMoveToPoint(context, centerX, centerY - radius * step / 5);
            }
            else {
                //                CGContextSetLineDash(context, 0, dashedPattern, 2);
                CGContextAddLineToPoint(context, centerX - radius * sin(i * radPerV) * step / 5,
                                        centerY - radius * cos(i * radPerV) * step / 5);
            }
            
        }
        [RGBColor(217, 217, 217, 1) set];
        CGContextStrokePath(context);
        
        //第二个for循环画填充色
        for (int i = 0; i <= numOfAngle; ++i) {
            if (i == 0) {
                CGContextMoveToPoint(context, centerX, centerY - radius * step / 5);
            }
            else {
                //                CGContextSetLineDash(context, 0, dashedPattern, 2);
                CGContextAddLineToPoint(context, centerX - radius * sin(i * radPerV) * step / 5,
                                        centerY - radius * cos(i * radPerV) * step / 5);
            }
            
            
        }
        
        if (step % 2 == 0) {
            
            [RGBColor(239, 241, 245, 82) setFill];
            CGContextFillPath(context);
        }
        else
        {
            [[UIColor whiteColor] set];
            CGContextFillPath(context);
        }
    }
    CGContextRestoreGState(context);
    
    
    //draw lines from center
    [RGBColor(217, 217, 217, 1) set];
    CGContextSetLineWidth(context, 0.5);
    for (int i = 0; i < numOfAngle; i++) {
        CGContextMoveToPoint(context, centerPoint.x, centerPoint.y);
        CGContextAddLineToPoint(context, centerPoint.x - radius * sin(i * radPerV),
                                centerPoint.y - radius * cos(i * radPerV));
        CGContextStrokePath(context);
    }
    
    //分数图
    _scoreView = [[RadarScoreView alloc] initWithFrame:self.bounds];
    _scoreView.backgroundColor = [UIColor clearColor];
    [self addSubview:_scoreView];
    _scoreView.transform = CGAffineTransformScale(_scoreView.transform, 0.3, 0.3);
    
    _scoreLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _scoreLabel.center = centerPoint;
    _scoreLabel.text = @"698";
    _scoreLabel.textColor = [UIColor whiteColor];
    _scoreLabel.font = [UIFont systemFontOfSize:30];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_scoreLabel];
    
    [self startAnimation];
}

- (void)startAnimation
{
    [UIView animateWithDuration:1 animations:^{
        _scoreView.transform = CGAffineTransformIdentity;
    }];
}


@end
