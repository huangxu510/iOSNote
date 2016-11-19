//
//  ViewController.m
//  Socket
//
//  Created by huangxu on 2016/11/19.
//  Copyright © 2016年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"

// 服务端
@interface ViewController () <GCDAsyncSocketDelegate>

@property (weak, nonatomic) IBOutlet UITextField *portTextField;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UITextView *showContentMessageTextView;

// 服务器socket（开放端口，监听客户端socket的链接）
@property (strong, nonatomic) GCDAsyncSocket *serverSocket;

// 保存客户端socket
@property (strong, nonatomic) GCDAsyncSocket *clientSocket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.serverSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 开始监听
- (IBAction)startReceive:(id)sender
{
    NSError *error = nil;
    BOOL result = [self.serverSocket acceptOnPort:self.portTextField.text.integerValue error:&error];
    
    if (result && error == nil) {
        [self showMessageWithStr:@"监听成功"];
    }
}

// 发送消息
- (IBAction)sendMessage:(id)sender
{
    NSData *data = [self.messageTextField.text dataUsingEncoding:NSUTF8StringEncoding];
    [self.clientSocket writeData:data withTimeout:-1 tag:0];
}

// 接收消息
- (IBAction)receiveMessage:(id)sender
{
    [self.clientSocket readDataWithTimeout:10 tag:0];
}

- (void)showMessageWithStr:(NSString *)str
{
    self.showContentMessageTextView.text = [self.showContentMessageTextView.text stringByAppendingFormat:@"%@\n", str];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    // 保存客户端的socket
    self.clientSocket = newSocket;
    [self showMessageWithStr:@"链接成功"];
    
    NSString *message = [NSString stringWithFormat:@"服务器地址：%@ - 端口：%d", newSocket.connectedHost, newSocket.connectedPort];
    [self showMessageWithStr:message];
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



