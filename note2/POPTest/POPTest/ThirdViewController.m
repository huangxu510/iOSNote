//
//  ThirdViewController.m
//  POPTest
//
//  Created by huangxu on 16/5/16.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ThirdViewController.h"
#import <POP.h>

@interface ThirdViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
@implementation ThirdViewController

- (IBAction)changeAlpha:(id)sender
{
    POPBasicAnimation *basicAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.duration = 1.0f;
    CGFloat alpha = self.imageView.alpha;
    if (alpha == 0) {
        basicAnimation.toValue = @(1.0);
    } else {
        basicAnimation.toValue = @(0.0);
    }
    
    [self.imageView pop_addAnimation:basicAnimation forKey:@"changeAlpha"];
}
@end
