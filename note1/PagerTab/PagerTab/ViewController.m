//
//  ViewController.m
//  PagerTab
//
//  Created by huangxu on 15/12/29.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) UIView *topLabelContainerView;
@property (nonatomic, strong) UIView *redContainerView;
@property (nonatomic, strong) UIView *redView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.titles = @[@"首页", @"库存", @"货单", @"设置"];
    [self createUI];
}

- (void)createUI
{
    for (NSInteger i = 0; i < self.titles.count; i++) {
        CGRect frame = [self calculateFrameWidthIndex:i top:NO];
        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:frame];
        bottomLabel.textColor = [UIColor redColor];
        bottomLabel.text = self.titles[i];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:25.0f];
        [self.view addSubview:bottomLabel];
    }
    
    _redContainerView = [[UIView alloc] initWithFrame:[self calculateFrameWidthIndex:0 top:NO]];
    _redContainerView.clipsToBounds = YES;
    [self.view addSubview:_redContainerView];
    
    
    _redView = [[UIView alloc] initWithFrame:[self calculateFrameWidthIndex:0 top:YES]];
    _redView.layer.cornerRadius = 25;
    _redView.backgroundColor = [UIColor redColor];
    [_redContainerView addSubview:_redView];
    
    
    _topLabelContainerView = [[UIView alloc] initWithFrame:[self calculateFrameWidthIndex:0 top:YES]];
//    _topLabelContainerView.backgroundColor = [UIColor blueColor];
    [_redContainerView addSubview:_topLabelContainerView];
                                                                            
    
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        CGRect frame = [self calculateFrameWidthIndex:i top:YES];
        UILabel *topLabel = [[UILabel alloc] initWithFrame:frame];
        topLabel.textColor = [UIColor whiteColor];
        topLabel.text = self.titles[i];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.font = [UIFont systemFontOfSize:25.0f];
        [_topLabelContainerView addSubview:topLabel];
    }
    
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeSystem];
        topButton.frame = [self calculateFrameWidthIndex:i top:NO];
        [self.view addSubview:topButton];
        topButton.tag = i;
        [topButton addTarget:self action:@selector(labelTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (CGRect)calculateFrameWidthIndex:(NSInteger)index top:(BOOL)top
{
    CGFloat labelWidth = (self.view.frame.size.width) / self.titles.count;
    CGFloat labelHeight = 50;
    CGFloat x = labelWidth * index;
    CGFloat y = top ? 0 : 100;
    return CGRectMake(x, y, labelWidth, labelHeight);
}

- (void)labelTapped:(UIButton *)button
{
    CGRect newFrame = [self calculateFrameWidthIndex:button.tag top:NO];
    CGRect changeFrame = [self calculateFrameWidthIndex:-button.tag top:YES];
    [UIView animateWithDuration:1 animations:^{
        _redContainerView.frame = newFrame;
        _topLabelContainerView.frame = changeFrame;
    } completion:^(BOOL finished) {
        [self shakeAnimation];
    }];
}

- (void)shakeAnimation
{
    CALayer *layer = _redView.layer;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    CGPoint fromPoint = layer.position;
    CGPoint pointA = CGPointMake(fromPoint.x + 1, fromPoint.y);
    CGPoint pointB = CGPointMake(fromPoint.x - 1, fromPoint.y);
    [animation setFromValue:[NSValue valueWithCGPoint:pointA]];
    [animation setToValue:[NSValue valueWithCGPoint:pointB]];
    [animation setDuration:0.1];
    [animation setRepeatCount:5];
    [layer addAnimation:animation forKey:nil];
}

@end
