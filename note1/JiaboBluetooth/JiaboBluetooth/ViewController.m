//
//  ViewController.m
//  JiaboBluetooth
//
//  Created by huangxu on 15/11/18.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "TscCommand.h"
#import "BLKWrite.h"
#import "EscCommand.h"
#import "ConnectViewController.h"

@interface ViewController ()
{
    ConnectViewController *_connectVC;
}

@property (retain, nonatomic) IBOutlet UITextField *contentTextField;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _connectVC = [[ConnectViewController alloc] initWithNibName:nil bundle:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        while (1) {
            
            sleep(5);
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if ([[BLKWrite Instance] isConnecting]) {
                    self.statusLabel.text = @"Connected";
                }
                else{
                    self.statusLabel.text = @"Disconnect";
                }
                    
            });
        }
    });
}

- (IBAction)scan:(id)sender
{
    [self.navigationController pushViewController:_connectVC animated:YES];
}

- (IBAction)printBarCode:(id)sender
{
    EscCommand *escCmd = [[EscCommand alloc] init];
    
    /*
     一定会发送的设置项
     */
    //打印机初始化，清空缓存
    [escCmd addInitializePrinter];
    //文本
    [escCmd addText: _contentTextField.text];
    
    [escCmd addPrintMode: 0x1B];
    [escCmd addPrintAndFeedLines:8];
    
    [[BLKWrite Instance] writeEscData:[escCmd getCommand]];

}

- (void)dealloc {
    [_statusLabel release];
    [_contentTextField release];
    [super dealloc];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
