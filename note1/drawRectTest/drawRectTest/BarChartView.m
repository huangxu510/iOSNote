//
//  BarChartView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "BarChartView.h"
#import "UIView+JCHQuartz2D.h"

@interface BarChartView ()
{
    NSArray *_values;
    NSInteger _index;
    CGFloat _barWidth;
    CGFloat _leftMargin;
}
@end

@implementation BarChartView


- (id)initWithFrame:(CGRect)frame values:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
        _values = values;
        _index = 0;
        _barWidth = 0;
        _leftMargin = 0;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    _leftMargin = 30;
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    _barWidth = (width - 2 * _leftMargin) / (2 * _values.count - 1);
    
    
    
    //画bar背景
    [self.barBackgroundColor set];
    for (NSInteger i = 0; i < _values.count; i++) {
        CGRect barBackgroundRect = CGRectMake(_leftMargin + i * _barWidth * 2, 0, _barWidth, height);
        [self drawRectangle:barBackgroundRect];
    }
    
    //画柱子
    NSArray *sortedValues = [_values sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
//        NSComparisonResult result = [obj1 compare:obj2];
        return obj1.doubleValue > obj2.doubleValue;
    }];
    
    NSLog(@"%@", sortedValues);

    CGFloat min = [[sortedValues firstObject] floatValue];
    CGFloat max = [[sortedValues lastObject] floatValue];
    CGFloat currentValue = 0;
    CGFloat barHeight = height;
    for (NSInteger i = 0; i < _values.count; i++) {
        [self.barColor set];
        currentValue = [_values[i] floatValue];
        
        if (max != min) {
            barHeight = currentValue * (300 / (max + 100));
        }
        CGRect barRect = CGRectMake(_leftMargin + i * _barWidth * 2, height - barHeight, _barWidth, barHeight);
       
        if (i == _index) {
            [self.selectedBarColor set];
            [self drawRectangle:barRect];
            [self drawIndexLine:barRect];
        }
        else
        {
            [self drawRectangle:barRect];
        }
    }
    
    [[UIColor whiteColor] set];
    //画顶部线
    [self drawLineFrom:CGPointMake(0, 0)
                    to:CGPointMake(width, 0)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(touchPoint));
    for (NSInteger i = 0; i < _values.count; i++) {
        if ((touchPoint.x >= _leftMargin + i * _barWidth * 2) &&
            (touchPoint.x <= (_leftMargin + i * _barWidth * 2 + _barWidth))) {
            _index = i;
            [self setNeedsDisplay];
            return;
        }
    }
}

- (void)drawIndexLine:(CGRect)currentBarRect
{
    CGPoint point1 = CGPointMake(currentBarRect.origin.x + currentBarRect.size.width / 2, _barWidth / 2);
    CGPoint point2 = CGPointMake(currentBarRect.origin.x + currentBarRect.size.width, 0);
    CGPoint point3 = CGPointMake(currentBarRect.origin.x , 0);
    CGPoint point4 = CGPointMake(currentBarRect.origin.x + currentBarRect.size.width / 2, self.frame.size.height - _barWidth / 2);
    CGPoint point5 = CGPointMake(currentBarRect.origin.x + currentBarRect.size.width, self.frame.size.height);
    CGPoint point6 = CGPointMake(currentBarRect.origin.x, self.frame.size.height);
    
    [[UIColor whiteColor] set];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(ctx);
    CGContextMoveToPoint(ctx, point1.x, point1.y);
    CGContextAddLineToPoint(ctx, point2.x, point2.y);
    CGContextAddLineToPoint(ctx, point3.x, point3.y);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, 0.7);
    CGContextMoveToPoint(ctx, point1.x, point1.y);
    CGContextAddLineToPoint(ctx, point4.x, point4.y);
    CGContextStrokePath(ctx);
    CGContextRestoreGState(ctx);
    
    CGContextMoveToPoint(ctx, point4.x, point4.y);
    CGContextAddLineToPoint(ctx, point5.x, point5.y);
    CGContextAddLineToPoint(ctx, point6.x, point6.y);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
    
}


@end
