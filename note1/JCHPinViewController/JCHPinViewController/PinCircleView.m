//
//  PinCircleVIew.m
//  JCHPinViewController
//
//  Created by huangxu on 15/11/16.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "PinCircleView.h"

@implementation PinCircleView
{
    CGFloat _leftMargin;
    CGFloat _spaceMargin;
    CGFloat _diameter;  // 直径
    CGFloat _topMargin;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _leftMargin = 90;
        _diameter = 15;
        _spaceMargin = (CGRectGetWidth(self.frame) - 2 * _leftMargin - 4 * _diameter) / 3;
        _topMargin = 150;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [[UIColor grayColor] set];
    CGContextSetLineWidth(ctx, 1.5);
    
    for (NSInteger i = 0; i < 4; i++) {
        CGContextAddEllipseInRect(ctx, CGRectMake(_leftMargin + i * (_diameter + _spaceMargin), _topMargin, _diameter, _diameter));
        if (self.codeLength > i) {
            CGContextFillPath(ctx);
        }
        else
        {
             CGContextStrokePath(ctx);
        }
       
    }
}


@end
