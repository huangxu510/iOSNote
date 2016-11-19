//
//  ViewController.m
//  Socket_Client
//
//  Created by huangxu on 2016/11/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

@interface ViewController () <GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *showMessageTextView;

@property (strong, nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.clientSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startConnect:(id)sender
{
    [self.clientSocket connectToHost:self.addressTextField.text onPort:self.portTextField.text.integerValue error:nil];
}

- (IBAction)sendMessage:(id)sender
{
    NSData *data = [self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

- (IBAction)receiveMessage:(id)sender
{
    [self.clientSocket readDataWithTimeout:10 tag:0];
}

- (void)showMessageWithStr:(NSString*)str
{
    self.showMessageTextView.text = [self.showMessageTextView.text stringByAppendingFormat:@"%@\n", str];
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    [self showMessageWithStr:@"连接成功"];
    [self showMessageWithStr:[NSString stringWithFormat:@"服务器IP: %@", host]];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self showMessageWithStr:text];
    [self.clientSocket readDataWithTimeout:-1 tag:0];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}





@end
