//
//  ViewController.m
//  电话短信邮件
//
//  Created by huangxu on 15/9/25.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)callAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://10086"]];
    
}

- (IBAction)sendMessageAction:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"sms://10086"]];

}
- (IBAction)sendMail:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mail://490990685@qq.com"]];

}


@end
