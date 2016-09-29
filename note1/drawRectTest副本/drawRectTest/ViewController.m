//
//  ViewController.m
//  drawRectTest
//
//  Created by huangxu on 15/10/14.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "MyLineView.h"
#import "MyShapeView.h"
#import "MyCircleView.h"
#import "BarChartView.h"
#import "BezierPathView.h"
#import "RadarView.h"
#import "JCHPieChartView.h"

#define RGBColor(r,g,b,al) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(al)]

@interface ViewController ()
{
    BarChartView *_barChartView;
    BezierPathView *_bezierView;
    RadarView *_radarView;
    JCHPieChartView *_pieView;
}
@end



@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self createRadarView];
    [self createPieChartView];
    
    
    
#if 0
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor redColor].CGColor;
    layer.position = CGPointMake(100, 0);
    layer.anchorPoint = CGPointMake(0, 0);
    [self.view.layer addSublayer:layer];
    
//    layer.transform = CATransform3DMakeTranslation(0, 0, 0);
//    layer.transform = CATransform3DMakeTranslation(100, 100, 0);
//    layer.transform = CATransform3DMakeTranslation(100, 100, 0);
    layer.transform = CATransform3DTranslate(layer.transform, 0, 0, 0);
#endif
    
    
    UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshButton addTarget:self  action:@selector(refreshAction) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setTitle:@"切换" forState:UIControlStateNormal];
    refreshButton.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
    [self.view addSubview:refreshButton];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    [_pieView startAnimation];
}

- (void)createPieChartView
{
    _pieView = [[JCHPieChartView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 300)];
    _pieView.backgroundColor = RGBColor(54, 57, 95, 1);
    [self.view addSubview:_pieView];
    
    
}

- (void)createRadarView
{
    _radarView = [[RadarView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 300)];
    [self.view addSubview:_radarView];

}

- (void)createBarChartView
{
    UIColor *barColor = RGBColor(166, 194, 255, 0.15);//RGBColor(76, 114, 202, 1.0);
    UIColor *selectedBarColor = RGBColor(166, 194, 255, 1);//RGBColor(166, 194, 255, 1.0);
    UIColor *barBackgroundColor = RGBColor(60, 91, 167, 1.0);
    UIColor *backgroundColor = RGBColor(58, 88, 166, 1.0);
    
    
    NSArray *values = @[@"90", @"100", @"150", @"80",@"40", @"200", @"170"];
    _barChartView = [[BarChartView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 300) values:values];
    _barChartView.backgroundColor = backgroundColor;
    _barChartView.barBackgroundColor = barBackgroundColor;
    _barChartView.barColor = barColor;
    _barChartView.selectedBarColor = selectedBarColor;
    
    [self.view addSubview:_barChartView];
    
}

- (void)createBezierView
{
    
    UIColor *barColor = RGBColor(166, 194, 255, 0.15);//RGBColor(76, 114, 202, 1.0);
    UIColor *selectedBarColor = RGBColor(166, 194, 255, 1);//RGBColor(166, 194, 255, 1.0);
    UIColor *barBackgroundColor = RGBColor(60, 91, 167, 1.0);
    UIColor *backgroundColor = RGBColor(58, 88, 166, 1.0);
    
    NSArray *values = @[@"90", @"100", @"150", @"80",@"40", @"200", @"170"];
    _bezierView = [[BezierPathView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 300) values:values];
    _bezierView.backgroundColor = backgroundColor;
    _bezierView.barColor = barColor;
    _bezierView.barBackgroundColor = barBackgroundColor;
    _bezierView.selectedBarColor = selectedBarColor;
    [self.view addSubview:_bezierView];

}

- (void)refreshAction
{
    if (_bezierView == nil) {
        [_radarView removeFromSuperview];
        _radarView = nil;
        [self createBezierView];
    }
    else
    {
        [_bezierView removeFromSuperview];
        _bezierView = nil;
        [self createRadarView];
    }
//    [_bezierView setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
