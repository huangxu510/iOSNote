//
//  UINavigationController+MyNav.m
//  PushPresentText
//
//  Created by huangxu on 15/12/31.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "UINavigationController+MyNav.h"

@implementation UINavigationController (MyNav)

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIGestureRecognizer *gesture = self.interactivePopGestureRecognizer;
    gesture.enabled = NO;
    
    UIView *gestureView = gesture.view;
    
    NSMutableArray *targets = [gesture valueForKey:@"targets"];
    
    id gestureRecognizerTarget = [targets firstObject];
    
    id navigationInteractiveTransition = [gestureRecognizerTarget valueForKey:@"target"];
    
    SEL handleTransition = NSSelectorFromString(@"handleNavigationTransition:");
    
    UIPanGestureRecognizer *popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:navigationInteractiveTransition action:handleTransition];
    popRecognizer.delegate = self;
    [gestureView addGestureRecognizer:popRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return self.viewControllers.count != 1 && ![[self valueForKey:@"isTransitioning"] boolValue];
}


@end
