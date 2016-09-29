//
//  PieChartView.h
//  drawRectTest
//
//  Created by huangxu on 15/10/21.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieChartView : UIView

@property (nonatomic, strong) NSArray *values;

- (void)startAnimation;

@end
