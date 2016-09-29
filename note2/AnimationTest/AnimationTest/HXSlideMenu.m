//
//  FlexualView.m
//  AnimationTest
//
//  Created by huangxu on 16/1/20.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "HXSlideMenu.h"

#define kExtraArea 30

@implementation HXSlideMenu
{
    UIVisualEffectView *_blurView;
    UIView *_helperSideView;
    UIWindow *_keyWindow;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _keyWindow = [UIApplication sharedApplication].windows[0];
        
        //_blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        //_blurView.frame = _keyWindow.frame;

        //_blurView.alpha = 1.0f;

        
        self.frame = CGRectMake(-(_keyWindow.bounds.size.width / 2 + kExtraArea), 0, _keyWindow.bounds.size.width / 2 + kExtraArea, _keyWindow.bounds.size.height);
        self.backgroundColor = [UIColor redColor];
        [_keyWindow addSubview:self];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)triger
{
    [_keyWindow bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = self.bounds;
    }];
}

- (void)hideAction
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-(_keyWindow.bounds.size.width / 2 + kExtraArea), 0, _keyWindow.bounds.size.width / 2 + kExtraArea, _keyWindow.bounds.size.height);
    }];
    CALayer *layer = [self.layer presentationLayer];
}

@end
