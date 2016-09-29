//
//  ViewController.m
//  POPTest
//
//  Created by huangxu on 16/5/13.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <POP.h>

@interface ViewController () <POPAnimationDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chageSize:)];
    [self.view addGestureRecognizer:tap];
}

- (void)chageSize:(UITapGestureRecognizer *)tap
{
    POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    CGRect frame = _imageView.frame;
    if (frame.size.width == 100) {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(300, 300)];
    } else {
        springAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(100, 100)];
    }
    
    //弹性值
    springAnimation.springBounciness = 20.0f;
    
    //弹性速度
    springAnimation.springSpeed = 20.0f;
    springAnimation.delegate = self;
    
    [_imageView.layer pop_addAnimation:springAnimation forKey:@"changeSize"];
}

- (void)pop_animationDidStart:(POPAnimation *)anim
{
    NSLog(@"Animation Did Start!");
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished
{
    NSLog(@"Animation Did Stop!");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
