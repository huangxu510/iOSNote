//
//  JCHTabBarButton.m
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//
#define JCHTabBarButtonImageRatio 0.6
#define JCHTabBarButtonTitleColor [UIColor grayColor]
#define JCHTabBarButtonTitleSelectedColor [UIColor redColor]

#import "JCHTabBarButton.h"

@implementation JCHTabBarButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:11];
        
        [self setTitleColor:JCHTabBarButtonTitleColor forState:UIControlStateNormal];
        [self setTitleColor:JCHTabBarButtonTitleSelectedColor forState:UIControlStateSelected];
    }
    return self;
}

//重写取消点击高亮
- (void)setHighlighted:(BOOL)highlighted
{
    
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * JCHTabBarButtonImageRatio;
    
    return CGRectMake(0, 0, imageWidth, imageHeight);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleY = contentRect.size.height * JCHTabBarButtonImageRatio;
    CGFloat titleWidth = contentRect.size.width;
    CGFloat titleHeight = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleWidth, titleHeight);
}

- (void)setItem:(UITabBarItem *)item
{
    [self setTitle:item.title forState:UIControlStateNormal];
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
}

@end
