
//
//  PieChartView.m
//  drawRectTest
//
//  Created by huangxu on 15/10/21.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "JCHPieChartView.h"
#import "SectorLayer.h"

@implementation ArrowLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextMoveToPoint(ctx, self.frame.size.width / 2, 0);
    CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height);
    CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
    CGContextClosePath(ctx);
    CGContextFillPath(ctx);
}

@end


@interface JCHPieChartView ()
{
    CGFloat _startAngle;
    CGFloat _deltaAngle;
    CGPoint _centerPoint;
    UIView *_containerView;
    NSInteger _index;
    CGFloat _sectorRadius;
    CGFloat _centerCircleRadius;
    CGFloat _containerViewAngleOffset; //containerView的角度偏移
    
}
//存放每个扇形的起始角度和结束角度,元素为字典
@property (nonatomic, strong) NSMutableArray *angles;
@property (nonatomic, strong) NSArray *colorRGBs;
@property (nonatomic, assign) CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *sectorLayers;

@end



@implementation JCHPieChartView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _startAngle = 0;
        _deltaAngle = 0;
        _containerViewAngleOffset = 0;
        _sectorRadius = 120;
        _centerCircleRadius = 50;
        self.angles = [NSMutableArray array];
        self.sectorLayers = [NSMutableArray array];

        [self createRGBs];
        self.values = @[@"150", @"100", @"130", @"300", @"20", @"60", @"30", @"200", @"80"];
        [self calculatePercentageFromValues:self.values];
        
        [self createUI];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //小于30度的要在左上角显示百分比
    for (NSInteger i = 0; i < self.sectorLayers.count; i++) {
        SectorLayer *layer = self.sectorLayers[i];
        
        if (((layer.endAngle - layer.startAngle) * 180 / M_PI) <= 20) {
             NSString *text = [NSString stringWithFormat:@"%.1f%% ", (layer.endAngle - layer.startAngle) / M_PI / 2 * 100];
            ColorRGB rgb;
            [self.colorRGBs[2 * (self.angles.count - i - 1) % 15] getValue:&rgb];
            
            CGContextSetRGBFillColor(ctx, rgb.colorR, rgb.colorG, rgb.colorB, 1);
//            CGContextAddRect(ctx, CGRectMake(20, 20 + i * 20, 10, 10));
            
            CGFloat topOffset = 20;
            CGFloat leftOffset = 20;
            CGFloat width = 10;
            CGFloat height = 10;
            CGFloat currentY = 2 * height * i + topOffset;
            CGFloat radius = 2;
            CGContextMoveToPoint(ctx, leftOffset + radius, currentY);
            //左上角弧度
            CGContextAddArcToPoint(ctx, leftOffset, currentY, leftOffset, currentY + radius, radius);
            //左下角
            CGContextAddArcToPoint(ctx, leftOffset, currentY + height, leftOffset + radius, currentY + height, radius);
            //右下角
            CGContextAddArcToPoint(ctx, leftOffset + width, currentY + height, leftOffset + width, currentY + height - radius, radius);
            //右上角
            CGContextAddArcToPoint(ctx, leftOffset + width, currentY, leftOffset + width - radius, currentY, radius);
            CGContextClosePath(ctx);
            CGContextFillPath(ctx);
//            CGContextStrokePath(ctx);
            
            [text drawInRect:CGRectMake(leftOffset + width + 5, currentY - 2, 40, 20) withAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:12]}];

        }
    }
}

- (void)createRGBs
{
    ColorRGB rgb1  = {89  / 255.0, 126 / 255.0, 240 / 255.0};
    ColorRGB rgb2  = {82  / 255.0, 169 / 255.0, 247 / 255.0};
    ColorRGB rgb3  = {31  / 255.0, 204 / 255.0, 203 / 255.0};
    ColorRGB rgb4  = {49  / 255.0, 215 / 255.0, 151 / 255.0};
    ColorRGB rgb5  = {106 / 255.0, 220 / 255.0, 123 / 255.0};
    ColorRGB rgb6  = {137 / 255.0, 227 / 255.0, 100 / 255.0};
    ColorRGB rgb7  = {234 / 255.0, 230 / 255.0, 134 / 255.0};
    ColorRGB rgb8  = {239 / 255.0, 202 / 255.0, 134 / 255.0};
    ColorRGB rgb9  = {255 / 255.0, 167 / 255.0, 104 / 255.0};
    ColorRGB rgb10 = {255 / 255.0, 98  / 255.0, 98  / 255.0};
    ColorRGB rgb11 = {231 / 255.0, 105 / 255.0, 105 / 255.0};
    ColorRGB rgb12 = {231 / 255.0, 105 / 255.0, 170 / 255.0};
    ColorRGB rgb13 = {197 / 255.0, 100 / 255.0, 239 / 255.0};
    ColorRGB rgb14 = {160 / 255.0, 100 / 255.0, 239 / 255.0};
    ColorRGB rgb15 = {117 / 255.0, 89  / 255.0, 240 / 255.0};
    
    NSValue *rgbValue1 = [NSValue value:&rgb1 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue2 = [NSValue value:&rgb2 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue3 = [NSValue value:&rgb3 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue4 = [NSValue value:&rgb4 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue5 = [NSValue value:&rgb5 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue6 = [NSValue value:&rgb6 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue7 = [NSValue value:&rgb7 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue8 = [NSValue value:&rgb8 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue9 = [NSValue value:&rgb9 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue10 = [NSValue value:&rgb10 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue11 = [NSValue value:&rgb11 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue12 = [NSValue value:&rgb12 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue13 = [NSValue value:&rgb13 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue14 = [NSValue value:&rgb14 withObjCType:@encode(ColorRGB)];
    NSValue *rgbValue15 = [NSValue value:&rgb15 withObjCType:@encode(ColorRGB)];
    
    self.colorRGBs = @[rgbValue1, rgbValue2, rgbValue3, rgbValue4, rgbValue5, rgbValue6, rgbValue7, rgbValue8, rgbValue9, rgbValue10, rgbValue11, rgbValue12, rgbValue13, rgbValue14, rgbValue15];
}



- (void)createUI
{
    _index = self.values.count - 2;
    _centerPoint = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 250)];
    _containerView.center = _centerPoint;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapAction:)];
    [_containerView addGestureRecognizer:tap];
    
    
    [self addSubview:_containerView];
    
    for (NSInteger i = 0; i < self.angles.count; i++) {
        ColorRGB rgb;
        [self.colorRGBs[2 * (self.angles.count - i - 1) % 15] getValue:&rgb];
    
    
        SectorLayer *layer = [SectorLayer layer];
        layer.centerPoint = CGPointMake(_containerView.frame.size.width / 2, _containerView.frame.size.height / 2);
        layer.radius = _sectorRadius;
        layer.bounds = self.bounds;
        layer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        layer.anchorPoint = CGPointMake(0.5, 0.5);
        layer.colorRGB = rgb;
        NSNumber *startAngle = [self.angles[i] objectForKey:@"startAngle"];
        NSNumber *endAngle = [self.angles[i] objectForKey:@"endAngle"];
        layer.startAngle = startAngle.floatValue;
        layer.endAngle = endAngle.floatValue;
        layer.contentsScale = [[UIScreen mainScreen] scale];
        [layer setNeedsDisplay];

        [_containerView.layer addSublayer:layer];
        [self.sectorLayers addObject:layer];
        
    }

    
    //中心圆
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(_containerView.frame.size.width / 2, _containerView.frame.size.height / 2)
                    radius:_centerCircleRadius
                startAngle:0
                  endAngle:M_PI * 2
                 clockwise:NO];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = RGBColor(54, 57, 95, 1).CGColor;
    [_containerView.layer addSublayer:shapeLayer];
    

    

    
    UIBezierPath *arcPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(_containerView.frame.size.width / 2, _containerView.frame.size.height / 2)
                                                           radius:_centerCircleRadius - 1
                                                       startAngle:0
                                                         endAngle:M_PI * 2
                                                        clockwise:YES];
    
    CAShapeLayer *pieShapLayer = [CAShapeLayer layer];
    pieShapLayer.path = arcPath.CGPath;
    pieShapLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    pieShapLayer.fillColor = [[UIColor redColor] CGColor];
    pieShapLayer.lineWidth = 150;

    pieShapLayer.strokeStart = 0;
    pieShapLayer.strokeEnd = 1.0;
    _containerView.layer.mask = pieShapLayer;
    
    ArrowLayer *arrowLayer = [ArrowLayer layer];
    arrowLayer.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height);
    arrowLayer.anchorPoint = CGPointMake(0.5, 1);
    arrowLayer.bounds = CGRectMake(0, 0, 20, 15);
    arrowLayer.contentsScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:arrowLayer];
    [arrowLayer setNeedsDisplay];
}

- (void)startAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 0.5;
    animation.repeatCount = 0;
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [animation setValue:@"sector" forKey:@"animType"];
    [_containerView.layer.mask addAnimation:animation forKey:@"startAnimation"];
}

//点击某个layer使之转到最下面然后下沉
- (void)handleTapAction:(UITapGestureRecognizer *)tap
{
    CGPoint tapPoint = [tap locationInView:self];
    CGFloat dis = [self calculateDistanceFromCenter:tapPoint];
    
    if ((dis > _centerCircleRadius) && (dis < _sectorRadius)) {
        
        _containerView.userInteractionEnabled = NO;
      
        for (SectorLayer *layer in self.sectorLayers) {
            layer.textLayer.hidden = YES;
        }
        
        
        CGFloat dx = tapPoint.x  - _centerPoint.x;
        CGFloat dy = tapPoint.y  - _centerPoint.y;
        CGFloat angle = atan2(dy,dx);
        
        CGFloat tapAngleInContainer = angle + _containerViewAngleOffset;
        if (tapAngleInContainer < 0) {
            tapAngleInContainer += M_PI * 2;
        }
        tapAngleInContainer = fmod(tapAngleInContainer, M_PI * 2);
        NSLog(@"_containerViewAngleOffset = %f", _containerViewAngleOffset * 180 / M_PI);
        NSLog(@"tapAngleInContainer=%f,dis = %f", tapAngleInContainer * 180 / M_PI, dis);
        NSLog(@"angle = %f", angle * 180 / M_PI);
        for (NSInteger i = 0; i < self.angles.count; i++) {
            
            NSMutableDictionary *angle = self.angles[i];
            NSNumber *startAngleNumber = [angle objectForKey:@"startAngle"];
            NSNumber *endAngleNumber = [angle objectForKey:@"endAngle"];
            CGFloat startAngle = startAngleNumber.floatValue;
            CGFloat endAngle = endAngleNumber.floatValue;
            
            
            NSLog(@"i=%ld start = %f, end = %f",i, startAngle * 180 / M_PI, endAngle * 180 / M_PI);
            if (tapAngleInContainer < endAngle && tapAngleInContainer > startAngle) {
                
                //当前下沉的layer还原
                SectorLayer *layer = self.sectorLayers[_index];
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
                
                
//                animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_centerPoint.x, _centerPoint.y)];

                animation.duration = 0.3;
                animation.delegate = self;
                animation.removedOnCompletion = NO;
                animation.fillMode = kCAFillModeForwards;
                animation.delegate = self;
                
                [animation setValue:@"moveUp" forKey:@"animType"];
                
                [animation setValue:@(startAngle) forKey:@"startAngle"];
                [animation setValue:@(endAngle) forKey:@"endAngle"];
                [layer addAnimation:animation forKey:nil];
                
                _index = i;
                NSLog(@"index = %ld", _index);
            }
        }
    }
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([[anim valueForKey:@"animType"] isEqualToString:@"sector"]) {
        
        [_containerView.layer.mask removeFromSuperlayer];
        
        NSInteger count = self.angles.count;
        NSMutableDictionary *angle = self.angles[count - 2];
        NSNumber *startAngleNumber = [angle objectForKey:@"startAngle"];
        NSNumber *endAngleNumber = [angle objectForKey:@"endAngle"];
        CGFloat startAngle = startAngleNumber.floatValue;
        CGFloat endAngle = endAngleNumber.floatValue;
        CGFloat angleOffset = (startAngle + endAngle) / 2 - M_PI_2;
        _containerViewAngleOffset = angleOffset;

       
        [angle setValue:@(startAngle) forKey:@"startAngle"];
        [angle setValue:@(endAngle) forKey:@"endAngle"];
        
        //更新当前startAngle
        startAngle -= angleOffset;
        
        CGAffineTransform newTrans = CGAffineTransformMakeRotation(-angleOffset);
        [UIView animateWithDuration:1 animations:^{
            _containerView.transform = newTrans;
        } completion:^(BOOL finished) {
            
            SectorLayer *layer = self.sectorLayers[_index];
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_centerPoint.x + sinf(- _containerViewAngleOffset) * 5, _centerPoint.y + 5 * cosf(- _containerViewAngleOffset))];
            animation.duration = 0.3;
            animation.removedOnCompletion = NO;
            animation.delegate = self;
            [animation setValue:@"sink" forKey:@"animType"];
            animation.fillMode = kCAFillModeForwards;
            [layer addAnimation:animation forKey:@"sinkAnimation"];
        
        }];
        
        
    }
    else if ([[anim valueForKey:@"animType"] isEqualToString:@"sink"])
    {
        for (SectorLayer *layer in self.sectorLayers) {
            layer.textLayer.hidden = NO;
        }
        _containerView.userInteractionEnabled = YES;
    }
    else if([[anim valueForKey:@"animType"] isEqualToString:@"moveUp"])
    {
        
        CGFloat startAngle = [[anim valueForKey:@"startAngle"] doubleValue];
        CGFloat endAngle = [[anim valueForKey:@"endAngle"] doubleValue];
        
        CGFloat angle = (M_PI - (startAngle + endAngle - 2 * _containerViewAngleOffset)) / 2;
        _containerViewAngleOffset -= angle;
        CGAffineTransform transform = CGAffineTransformRotate(_containerView.transform, angle);

        
        
        [UIView animateWithDuration:0.5 animations:^{
            _containerView.transform = transform;

        } completion:^(BOOL finished) {
            
            //转动动画完成后layer下沉
            SectorLayer *layer = self.sectorLayers[_index];

            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_centerPoint.x + sinf(- _containerViewAngleOffset) * 5, _centerPoint.y + 5 * cosf(-_containerViewAngleOffset))];
            animation.duration = 0.3;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;
            animation.delegate = self;
            [animation setValue:@"sink" forKey:@"animType"];
            [layer addAnimation:animation forKey:nil];
            
        }];

    }
}

- (void)animationDidStart:(CAAnimation *)anim
{
    //下沉动画开始旋转textLayer
   if ([[anim valueForKey:@"animType"] isEqualToString:@"sink"])
    {
        for (SectorLayer *layer in self.sectorLayers) {
            layer.textLayer.transform = CATransform3DMakeRotation(_containerViewAngleOffset, 0, 0, 1);
        }
    }
}

- (void)calculatePercentageFromValues:(NSArray *)values
{
    NSArray *sortValues = [values sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return obj1.doubleValue > obj2.doubleValue;
    }];
    
    CGFloat totalValue = 0;
    for (NSString *value in sortValues)
    {
        totalValue += value.doubleValue;
    }
    
    
    for (NSString *value in sortValues) {
        NSMutableDictionary *angle = [NSMutableDictionary dictionary];
        
        CGFloat currentAngle = value.doubleValue / totalValue * M_PI * 2;
        
        [angle setValue:@(_startAngle) forKey:@"startAngle"];
        [angle setValue:@(_startAngle + currentAngle) forKey:@"endAngle"];
        
        _startAngle = _startAngle + currentAngle;
        
        [self.angles addObject:angle];
    }
}
- (float) calculateDistanceFromCenter:(CGPoint)point {
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
    
}


@end
