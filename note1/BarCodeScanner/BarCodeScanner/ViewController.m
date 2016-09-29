//
//  ViewController.m
//  BarCodeScanner
//
//  Created by huangxu on 15/11/30.
//  Copyright © 2015年 huangxu. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    UIView *_scanLine;
}

@property (nonatomic, strong) UIView *scanRectView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];

    self.view.backgroundColor = [UIColor blackColor];
    self.scanRectView = [[UIView alloc] init];
    self.scanRectView.backgroundColor = [UIColor clearColor];
    self.scanRectView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds)/3*2, CGRectGetWidth([UIScreen mainScreen].bounds)/3*2);
    self.scanRectView.center = self.view.center;
    
    //边框
    self.scanRectView.layer.borderWidth = 3;
    self.scanRectView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //阴影
    self.scanRectView.layer.shadowOffset = CGSizeMake(2, 2);
    self.scanRectView.layer.shadowRadius = 5;
    self.scanRectView.layer.shadowOpacity = 1;
    self.scanRectView.layer.shadowColor = [UIColor blackColor].CGColor;
    [self.view addSubview:self.scanRectView];
    
    //扫描线
    _scanLine = [[UIView alloc] init];
    _scanLine.frame = CGRectMake(0, 0, self.scanRectView.bounds.size.width, 1);
    _scanLine.backgroundColor = [UIColor greenColor];
    [self.scanRectView addSubview:_scanLine];
    
    [self moveScanLine];
    [self start];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.session startRunning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)start
{
    //1.摄像头设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    //2.设置输入
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"摄像头开启失败%@", error.localizedDescription);
        return;
    }
    
    //3.设置输出(Metadata元数据)
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    // 3.1 设置输出的代理
    // 说明：使用主线程队列，相应比较同步，使用其他队列，相应不同步，容易让用户产生不好的体验
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //4.拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    //添加session的输入输出
    [session addInput:input];
    [session addOutput:output];
    //使用1080p的图像输出
    session.sessionPreset = AVCaptureSessionPreset1920x1080;
    
    //4.1 设置输出的格式
    // 提示：一定要先设置会话的输出为output之后，再指定输出的元数据类型！
    [output setMetadataObjectTypes:[output availableMetadataObjectTypes]];
    //如下设置条形码和二维码兼容
    //[output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]];
    
    //5.设置预览图层（用来让用户能够看到扫描情况）
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = [UIScreen mainScreen].bounds;
    self.previewLayer = previewLayer;
    
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];

    
    //调整识别范围
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect cropRect = self.scanRectView.frame;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 1920./1080.;  //使用1080p的图像输出
    if (p1 < p2) {
        CGFloat fixHeight = [UIScreen mainScreen].bounds.size.width * 1920. / 1080.;
        CGFloat fixPadding = (fixHeight - size.height)/2;
        output.rectOfInterest = CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                           cropRect.origin.x/size.width,
                                           cropRect.size.height/fixHeight,
                                           cropRect.size.width/size.width);
    } else {
        CGFloat fixWidth = [UIScreen mainScreen].bounds.size.height * 1080. / 1920.;
        CGFloat fixPadding = (fixWidth - size.width)/2;
        output.rectOfInterest = CGRectMake(cropRect.origin.y/size.height,
                                           (cropRect.origin.x + fixPadding)/fixWidth,
                                           cropRect.size.height/size.height,
                                           cropRect.size.width/fixWidth);
    }
    self.session = session;
}

- (void)moveScanLine
{
    [UIView animateWithDuration:2 animations:^{
        _scanLine.transform = CGAffineTransformMakeTranslation(0, self.scanRectView.frame.size.height - 4);
    } completion:^(BOOL finished) {
        
        _scanLine.transform = CGAffineTransformIdentity;
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveScanLine) object:nil];
        [self performSelector:@selector(moveScanLine) withObject:nil afterDelay:0.2];
    }];
}

- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self.session  startRunning];
}
- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        [self.session stopRunning];
        NSLog(@"%@", obj.stringValue);
    }
}

@end
