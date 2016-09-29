//
//  ViewController.m
//  StrokeAnimation
//
//  Created by huangxu on 16/1/4.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self startStrokeAnimation];
    self.view.backgroundColor = [UIColor whiteColor];
    [self visualEffectView];
}

- (void)startStrokeAnimation
{
    CAShapeLayer *trackShapeLayer = [CAShapeLayer layer];
    trackShapeLayer.strokeColor = [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1].CGColor;
    trackShapeLayer.fillColor = [UIColor clearColor].CGColor;
    trackShapeLayer.lineWidth = 8;
    trackShapeLayer.path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
    [self.view.layer addSublayer:trackShapeLayer];
    
    CAShapeLayer *topShapeLayer = [CAShapeLayer layer];
    topShapeLayer.strokeColor = [UIColor colorWithRed:0.984 green:0.153 blue:0.039 alpha:1.000].CGColor;
    topShapeLayer.lineCap = kCALineCapRound;
    topShapeLayer.fillColor = [UIColor clearColor].CGColor;
    topShapeLayer.lineWidth = 8;
    topShapeLayer.path = [UIBezierPath bezierPathWithArcCenter:self.view.center radius:100 startAngle:-M_PI_2 endAngle:M_PI_2 * 3 clockwise:YES].CGPath;
    [self.view.layer addSublayer:topShapeLayer];
    
    //起点动画
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1);
    
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    animationGroup.duration = 2;
    animationGroup.repeatCount = NSIntegerMax;
    animationGroup.removedOnCompletion = NO;
    animationGroup.fillMode = kCAFillModeForwards;
    
    [topShapeLayer addAnimation:animationGroup forKey:nil];
    topShapeLayer.lineDashPattern = @[@20, @30];
}

- (void)startCircleAnimation
{

}

- (void)visualEffectView
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo"]];
    imageView.frame = CGRectMake(0, 0, 75, 75);
    //[self.view addSubview:imageView];
    UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [view.contentView addSubview:imageView];
    view.alpha = 0.5;
    view.frame = CGRectMake(100, 200, 75, 75);
    [self.view addSubview:view];
}

@end
