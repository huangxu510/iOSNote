//
//  SecondViewController.h
//  ReactiveCocoa
//
//  Created by huangxu on 15/10/8.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa.h>

@interface SecondViewController : ViewController

@property (nonatomic, strong) RACSubject *delegateSignal;

@end
