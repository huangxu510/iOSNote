//
//  BarChartView.h
//  drawRectTest
//
//  Created by huangxu on 15/10/15.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarChartView : UIView

@property (nonatomic, strong)UIColor *barColor;
@property (nonatomic, strong)UIColor *barBackgroundColor;
@property (nonatomic, strong)UIColor *selectedBarColor;

- (id)initWithFrame:(CGRect)frame values:(NSArray *)values;

@end
