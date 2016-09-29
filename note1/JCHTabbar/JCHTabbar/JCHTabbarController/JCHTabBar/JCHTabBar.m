//
//  JCHTabbar.m
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "JCHTabBar.h"
#import "JCHTabBarButton.h"

@interface JCHTabBar ()

@property (nonatomic, weak) JCHTabBarButton *selectedButton;

@end

@implementation JCHTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.4;
    }
    return self;
}
- (void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    JCHTabBarButton *button = [[JCHTabBarButton alloc] init];
    [self addSubview:button];
    
    button.item = item;

    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
    
    if (self.subviews.count == 1) {
        [self buttonClick:button];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat buttonY = 0;
    CGFloat buttonHeight = self.frame.size.height;
    CGFloat buttonWidth = self.frame.size.width / self.subviews.count;
    
    for (NSInteger index = 0; index < self.subviews.count; index++) {
        JCHTabBarButton *button = self.subviews[index];
        
        CGFloat buttonX = index * buttonWidth;
        button.frame = CGRectMake(buttonX, buttonY, buttonWidth, buttonHeight);
        
        button.tag = index;
    }
}

- (void)buttonClick:(JCHTabBarButton *)button
{
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectItemFrom:to:)]) {
        [self.delegate tabBar:self didSelectItemFrom:self.selectedButton.tag to:button.tag];
    }
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

@end
