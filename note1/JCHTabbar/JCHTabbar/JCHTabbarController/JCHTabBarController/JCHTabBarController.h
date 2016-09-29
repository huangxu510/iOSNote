//
//  JCHTabBarController.h
//  JCHTabbar
//
//  Created by huangxu on 15/11/13.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCHTabBarController : UITabBarController

- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

@end
