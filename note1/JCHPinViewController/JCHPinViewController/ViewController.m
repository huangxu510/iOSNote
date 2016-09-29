//
//  ViewController.m
//  JCHPinViewController
//
//  Created by huangxu on 15/11/16.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "PinCircleVIew.h"

@interface ViewController ()
{
    PinCircleView *_circleView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    textField.hidden = YES;
    [textField becomeFirstResponder];
    textField.keyboardType = UIKeyboardTypeNumberPad;
    [textField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    
    _circleView = [[PinCircleView alloc] initWithFrame:self.view.bounds];
    _circleView.backgroundColor = [UIColor cyanColor];
    _circleView.codeLength = 0;
    [self.view addSubview:_circleView];
}

- (void)editingChanged:(UITextField *)textField
{
    if (textField.text.length <= 4) {
        _circleView.codeLength = textField.text.length;
        [_circleView setNeedsDisplay];
    }
    else
    {
        textField.text = [textField.text substringToIndex:3];
    }
}

@end
