//
//  BezierPathVuew.m
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "BezierPathView.h"
#import "IndexView.h"

#define RGBColor(r,g,b,al) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(al)]


@interface BezierPathView ()
{
//    CAShapeLayer *_trackLayer;
//    CAShapeLayer *_progressLayer;
    NSArray *_values;
    NSMutableArray *_progressLayers;
    
    NSInteger _index;
    CGFloat _barWidth;
    CGFloat _leftMargin;
//    CAShapeLayer *_indexLayer;
    IndexView *_indexView;
    BOOL _indexViewIsMoving;
    CGFloat touchPreviousX;
}
@end

@implementation BezierPathView


- (instancetype)initWithFrame:(CGRect)frame values:(NSArray *)values
{
    self = [super initWithFrame:frame];
    if (self) {
       
        _values = values;
        _leftMargin = 30;
        _progressLayers = [NSMutableArray array];
        
    }
    
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    _index = 0;
    _barWidth = 0;
    touchPreviousX = 0;
    _indexViewIsMoving = NO;
    [_progressLayers removeAllObjects];
    
    for (NSInteger i = 0; i < self.layer.sublayers.count; i++) {
        CALayer *layer = self.layer.sublayers[i];
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
        
    }
    
    [_indexView removeFromSuperview];

    
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    _barWidth = (width - 2 * _leftMargin) / (2 * _values.count - 1);
    
    NSArray *sortedValues = [_values sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        //        NSComparisonResult result = [obj1 compare:obj2];
        return obj1.doubleValue > obj2.doubleValue;
    }];
    
    CGFloat min = [[sortedValues firstObject] floatValue];
    CGFloat max = [[sortedValues lastObject] floatValue];
    CGFloat currentValue = 0;
    CGFloat barHeight = 0;
    
    for (NSInteger i = 0; i < _values.count; i++) {
        
        //轨道layer
        CAShapeLayer *trackLayer = [CAShapeLayer layer];
        trackLayer.strokeColor = self.barBackgroundColor.CGColor;
        trackLayer.lineWidth = _barWidth;
        [self.layer addSublayer:trackLayer];
        
        CGFloat trackLayerX = _leftMargin + i * 2 * _barWidth + _barWidth / 2;
        UIBezierPath *trackPath = [UIBezierPath bezierPath];
        [trackPath moveToPoint:CGPointMake(trackLayerX , height)];
        [trackPath addLineToPoint:CGPointMake(trackLayerX, 0)];
        trackLayer.path = trackPath.CGPath;
        
        //进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.strokeColor = self.selectedBarColor.CGColor;
        progressLayer.lineWidth = _barWidth;
        progressLayer.opacity = 0.15;

//        progressLayer
        [self.layer addSublayer:progressLayer];
        [_progressLayers addObject:progressLayer];
        
        currentValue = [_values[i] floatValue];
        
        if (max != min) {
            barHeight = currentValue * (300 / (max + 100));
        }
        UIBezierPath *progressPath = [UIBezierPath bezierPath];
        [progressPath moveToPoint:CGPointMake(trackLayerX , height)];
        [progressPath addLineToPoint:CGPointMake(trackLayerX, height - barHeight)];
        progressLayer.path = progressPath.CGPath;
        
        
        CGRect indexViewFrame = CGRectMake(_leftMargin + i * 2 * _barWidth, 0, _barWidth, height);
        if (i == _values.count / 2) {
            //标识线
            _indexView = [[IndexView alloc] initWithFrame:indexViewFrame];
            _indexView.backgroundColor = [UIColor clearColor];
//            progressLayer.opacity = 1;
            _index = i;
        }
    }
    
   
    [self addSubview:_indexView];
    
    [self startAnimation:1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGFloat min = _leftMargin + _barWidth * 2 * _index;
    CGFloat max = _leftMargin + _barWidth * 2 * _index + _barWidth;
    
    if ((currentPoint.x >= min) && (currentPoint.x <= max) && !_indexViewIsMoving) {
        _indexViewIsMoving = YES;
        touchPreviousX = currentPoint.x;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    CGRect frame = _indexView.frame;
    CAShapeLayer *currentProgressLayer = _progressLayers[_index];
    [currentProgressLayer removeAllAnimations];
    CGFloat touchOffsetX = currentPoint.x - touchPreviousX;
    touchPreviousX = currentPoint.x;
    
    if (_indexViewIsMoving) {
        frame.origin.x += touchOffsetX;
        _indexView.frame = frame;

        CGFloat lineX = _indexView.frame.origin.x + _barWidth / 2;
        CGFloat oldLineX = _leftMargin + _barWidth * 2 * _index + _barWidth / 2;
        CGFloat lineOffsetX = lineX - oldLineX;

        if (fabs(lineOffsetX) >= (_barWidth / 2)) {
            currentProgressLayer.opacity = 0.15;
        }
        else
        {
            currentProgressLayer.opacity = 1 - fabs(lineOffsetX) * 0.85 / (_barWidth / 2);
        }
    
    }
    
    CGPoint lineViewCurrentPoint = _indexView.frame.origin;
    CGFloat lineX = lineViewCurrentPoint.x + _barWidth / 2;
    for (NSInteger i = 0; i < _values.count; i++) {
        CGFloat min = _leftMargin + _barWidth * 2 * i;
        CGFloat max = _leftMargin + _barWidth * 2 * i + _barWidth;
        if (((lineX >= min) && (lineX <= max)) ||
            (fabs(lineX - min) <= _barWidth / 2) ||
            (fabs(lineX - max) <= _barWidth / 2))
        {
            _index = i;
            return;
        }
        else if ((lineX < min && i == 0) || (lineX > max && i == _values.count - 1))
        {
            _index = i;
            return;
        }
    }
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _indexViewIsMoving = NO;
    

    CGRect frame = _indexView.frame;
    frame.origin.x = _leftMargin + _index * 2 * _barWidth;
    
    [UIView animateWithDuration:0.25 animations:^{
        _indexView.frame = frame;
    }];
    
    CAShapeLayer *currentProgressLayer = _progressLayers[_index];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.toValue = @(1);//(id)[self.selectedBarColor CGColor];
    animation.duration = 0.25;
    animation.repeatCount = 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [currentProgressLayer addAnimation:animation forKey:nil];
    return;
    
}

- (void)startAnimation:(CGFloat)duration
{

    for (NSInteger i = 0; i < _progressLayers.count; i++) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = duration;
        animation.fromValue = @(0.0);
        animation.toValue = @(1.0);
        animation.removedOnCompletion = NO;
        animation.repeatCount = 0;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        NSString *animationKey = nil;
        if (i == _progressLayers.count - 1)
        {
            animation.delegate = self;
        }
        
        CAShapeLayer *progressLayer = _progressLayers[i];
        [progressLayer addAnimation:animation forKey:animationKey];
    }
}


- (void)animationDidStart:(CAAnimation *)anim
{
    _indexView.alpha = 0;
    self.userInteractionEnabled = NO;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
//    animation.fromValue = (id)[self.barColor CGColor];
//    animation.toValue = (id)[self.selectedBarColor CGColor];
    animation.toValue = @(1);
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    CAShapeLayer *currentProgressLayer = _progressLayers[_index];
    [currentProgressLayer addAnimation:animation forKey:nil];
    
    [UIView animateWithDuration:1 animations:^{
        _indexView.alpha = 1;
    }];
    
    self.userInteractionEnabled = YES;
}

@end
