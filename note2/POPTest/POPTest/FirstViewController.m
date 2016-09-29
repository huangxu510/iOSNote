//
//  FirstViewController.m
//  POPTest
//
//  Created by huangxu on 16/5/16.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "FirstViewController.h"
#import <POP.h>

@interface FirstViewController ()

@property (weak, nonatomic) IBOutlet UIView *springView;
@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (IBAction)changePositon:(id)sender
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPosition];
    CGPoint point = self.springView.center;
    
    if (point.y == 240) {
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, -100)];
    } else {
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x, 240)];
    }
    
    springAnimation.springBounciness = 20.0f;
    springAnimation.springSpeed = 20.0f;
    
    [_springView.layer pop_addAnimation:springAnimation forKey:@"changePosition"];
}

@end
