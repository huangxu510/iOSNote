//
//  JCHTabbar.h
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JCHTabBar;


@protocol JCHTabBarDelegate <NSObject>

@optional
- (void)tabBar:(JCHTabBar *)tabBar didSelectItemFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface JCHTabBar : UIView

@property (nonatomic, weak)id <JCHTabBarDelegate> delegate;
- (void)addTabBarButtonWithItem:(UITabBarItem *)item;

@end
