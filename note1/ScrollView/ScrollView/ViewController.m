//
//  ViewController.m
//  ScrollView
//
//  Created by huangxu on 15/12/28.
//  Copyright © 2015年 huangxu. All rights reserved.
//
/**
 
 *
 *
 */
#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()
{
    UIScrollView *_contentScrollView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.backgroundColor = [UIColor yellowColor];

    [self.view addSubview:_contentScrollView];
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    
    UIView *lastView = nil;
    CGFloat height = 25;
    
    for (NSInteger i = 0; i < 10; i++) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [self randomColor];
        [_contentScrollView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastView ? lastView.mas_bottom : _contentScrollView.mas_top);
            make.left.equalTo(_contentScrollView);
            make.width.equalTo(_contentScrollView);
            make.height.equalTo(@(height));
        }];
        
        height += 25;
        lastView = view;
    }
    
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView);
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
