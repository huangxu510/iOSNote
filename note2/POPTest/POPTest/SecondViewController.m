//
//  SecondViewController.m
//  POPTest
//
//  Created by huangxu on 16/5/16.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "SecondViewController.h"
#import <POP.h>

@interface SecondViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *springView;
@end
@implementation SecondViewController


- (IBAction)changeSize:(UIPanGestureRecognizer *)pan
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    CGPoint point = [pan locationInView:self.view];
    springAnimation.toValue = [NSValue valueWithCGRect:CGRectMake(0, self.springView.frame.origin.y, point.x, point.y)];
    
    springAnimation.springBounciness = 20.0f;
    springAnimation.springSpeed = 20.0f;
    
    [self.springView pop_addAnimation:springAnimation forKey:@"changeFrame"];
}
@end
