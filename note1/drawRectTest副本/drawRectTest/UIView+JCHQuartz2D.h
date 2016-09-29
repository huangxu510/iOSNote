//
//  UIView+JCHQuartz2D.h
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (JCHQuartz2D)

- (void)drawRectangle:(CGRect)rect;
- (void)drawLineFrom:(CGPoint)startPoint to:(CGPoint)endPoint;

@end
