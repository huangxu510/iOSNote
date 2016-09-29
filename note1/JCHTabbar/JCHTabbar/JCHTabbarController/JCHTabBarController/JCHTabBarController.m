//
//  JCHTabBarController.m
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "JCHTabBarController.h"
#import "JCHTabBar.h"
#import "ViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "ForthViewController.h"

@interface JCHTabBarController () <JCHTabBarDelegate>

@property (nonatomic, weak) JCHTabBar *customTabBar;
@end
@implementation JCHTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 初始化tabbar
    [self setupTabbar];
    
    // 初始化所有的子控制器
    [self setupAllChildViewControllers];
    
    NSLog(@"subviews = %@", self.tabBar.subviews);
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    for (UIView *child in self.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
       }
    }
}

- (void)setupTabbar
{
    JCHTabBar *customTabBar = [[JCHTabBar alloc] init];
    customTabBar.frame = self.tabBar.bounds;
    customTabBar.delegate = self;
//    customTabBar.alpha = 0.8;
    [self.tabBar addSubview:customTabBar];
    
    self.customTabBar = customTabBar;
    
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.shadowImage = [[UIImage alloc] init];
}

- (void)setupAllChildViewControllers
{
    ViewController *first = [[ViewController alloc] init];
    [self setupChildViewController:first title:@"首页" imageName:@"nav_1_home_normal" selectedImageName:@"nav_1_home_active"];
    
    SecondViewController *second = [[SecondViewController alloc] init];
    [self setupChildViewController:second title:@"货单" imageName:@"nav_2_manifest_normal" selectedImageName:@"nav_2_manifest_active"];
    
    ThirdViewController *third = [[ThirdViewController alloc] init];
    [self setupChildViewController:third title:@"库存" imageName:@"nav_3_inventory_normal" selectedImageName:@"nav_3_inventory_active"];
    
    ForthViewController *forth = [[ForthViewController alloc] init];
    [self setupChildViewController:forth title:@"我的" imageName:@"nav_5_me_normal" selectedImageName:@"nav_5_me_active"];
}

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    // 1.设置控制器的属性
    childVc.title = title;
    // 设置图标
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
   
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    // 2.包装一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
    
    // 3.添加tabbar内部的按钮
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
}

#pragma mark - JCHTabBarDelegate
- (void)tabBar:(JCHTabBar *)tabBar didSelectItemFrom:(NSInteger)from to:(NSInteger)to
{
    [self setSelectedIndex:to];
}

@end
