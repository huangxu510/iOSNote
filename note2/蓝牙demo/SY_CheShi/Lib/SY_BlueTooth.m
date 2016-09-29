//
//  SY_BlueTooth.m
//  SYElectronicScale
//
//  Created by 钱学明 on 15/12/17.
//  Copyright © 2015年 钱学明. All rights reserved.
//

#import "SY_BlueTooth.h"
#import <CoreBluetooth/CoreBluetooth.h>


@interface SY_BlueTooth()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) NSTimer * timer;
@property (nonatomic, strong) CBCentralManager * manager;      //中心
@property (nonatomic, strong) CBPeripheral * diccoverPeripheral;
@property (nonatomic, strong) NSMutableArray * peripheralMarr; //接收 外设 的数组

@end

static NSString * deviceName = @"Ast LE Mouse";   //外设名称

@implementation SY_BlueTooth

-(NSMutableArray *)peripheralMarr{
    if (_peripheralMarr == nil) {
        _peripheralMarr = @[].mutableCopy;
    }
    return _peripheralMarr;
}

static SY_BlueTooth * blue = nil;
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (blue == nil) {
            blue = [[[self class] alloc] init];
        }
    });
    return blue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
        _manager = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
    }
    return self;
}

//连接
-(void)startScan:(CBPeripheral *)peripheral{
    NSDictionary * dic = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
    [_manager connectPeripheral:peripheral options:dic];
}
-(void)cleanUp{
    if (!self.diccoverPeripheral.isProxy) {
        return;
    }
    if (self.diccoverPeripheral.services != nil) {
        for (CBService *service in self.diccoverPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                       if (characteristic.isNotifying) {
                            [self.diccoverPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                          return;
                    }
                }
            }
        }
    }
    [self.manager cancelPeripheralConnection:self.diccoverPeripheral];
}
#pragma mark--------central协议-------------
//设备成功打开的委托方法，并在此委托方法中扫描设备
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    NSLog(@"开始搜索周边设备");
    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
    /*
     第一个参数nil就是扫描周围所有的外设
     第二个参数options的意思是否允许中央设备多次收到曾经监听到的设备的消息，这样来监听外围设备联接的信号强度，以决定是否增大广播强度，为YES时会多耗电
     */
}
//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    //RSSI == 信号强度值
    //advertisementData == 外设 发出的广告 数据
    if ([peripheral.name isEqualToString:deviceName]) {
        for (CBPeripheral * per in self.peripheralMarr) {
            if ([per.name isEqualToString:peripheral.name]) {
                [self.peripheralMarr removeObject:per];
            }
        }
    }
    
    [self.peripheralMarr addObject:peripheral];
    
    for (CBPeripheral * per in self.peripheralMarr) {
        if ([per.name isEqualToString:deviceName]) {
            self.diccoverPeripheral = per;
        }
    }
    NSLog(@">>>搜索到的外设数组 包含 == %@",self.peripheralMarr);
    [self startScan:self.diccoverPeripheral];
}
/**
 *  链接结果
 *
 *  链接成功 -(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
 *  链接失败 -(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 *  链接断开 -(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
 *
 *  @return  链接结果
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    [self.manager stopScan];
    //设置外设的代理
    [peripheral setDelegate:self];
    //告诉外围设备，谁与外围设备连接
    [peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
    [self cleanUp];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    self.diccoverPeripheral = nil;
    [self startScan:peripheral];
}

#pragma mark--------连接成功后 执行以下协议---------------
//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@">>>扫描到服务：%@",peripheral.services);
    if (error){
        NSLog(@">>>服务的名字： %@ with 错误原因: %@", peripheral.name, [error localizedDescription]);
        [self cleanUp];
        return;
    }
    if (!self.timer) {
        //计时器  设定  多久  扫描一次
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(discoverServices:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    if (error){
        NSLog(@"服务的错误原因 for %@ with error: %@", service.UUID, [error localizedDescription]);
        [self cleanUp];
        return;
    }
    for (CBService * service in peripheral.services) {
        if (service != nil) {
            for (CBCharacteristic *characteristic in service.characteristics){
                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            }
            for (CBCharacteristic *characteristic in service.characteristics){
                [peripheral readValueForCharacteristic:characteristic];
                [peripheral discoverDescriptorsForCharacteristic:characteristic];
            }
        }
    }

}

//-(void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
//    if (!error){
//        NSLog(@"notification 出现错误");
//        [self cleanUp];
//        return;
//    }
//    NSLog(@"看看");
//    for (CBService * service in peripheral.services) {
//        if (service != nil) {
//            for (CBCharacteristic *characteristic in service.characteristics){
//                [peripheral setNotifyValue:YES forCharacteristic:characteristic];
//            }
//            for (CBCharacteristic *characteristic in service.characteristics){
//                [peripheral readValueForCharacteristic:characteristic];
//                [peripheral discoverDescriptorsForCharacteristic:characteristic];
//            }
//        }
//    }
//}
#pragma ====================================================================================================================获取蓝牙数据=========================================================================================================================================
//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"服务: == %@ ,特征 uuid:== %@  value:== %@",peripheral.services,characteristic.UUID,characteristic.value);
    // Scanner uses other queue to send events. We must edit UI in the main queue
}

//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    if (error) {
        NSLog(@"错误 characteristics: %@", [error localizedDescription]);
        return;
    }
#pragma mark-----------官方---------------------
//    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
//    
//    // Have we got everything we need?
//    if ([stringFromData isEqualToString:@"EOM"]) {
//        
//        // We have, so show the data,
//        [self.textview setText:[[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]];
//        
//        // Cancel our subscription to the characteristic
//        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
//        
//        // and disconnect from the peripehral
//        [self.centralManager cancelPeripheralConnection:peripheral];
//    }
//    
//    // Otherwise, just add the data on to what we already have
//    [self.data appendData:characteristic.value];
    // Log it
//    NSLog(@"Received: %@", stringFromData);
    
#pragma mark-------------------------------------
    
    //打印出Characteristic和他的Descriptors
    //NSLog(@"特征 uuid:%@",characteristic.UUID);
    for (CBDescriptor *d in characteristic.descriptors) {
        //NSLog(@"UUID 的 描述 uuid:%@",d.UUID);
        NSLog(@"%@",d);
    }
}

//获取到Descriptors的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    //打印出DescriptorsUUID 和value
    //这个descriptor都是对于characteristic的描述，一般都是字符串，所以这里我们转换成字符串去解析
    NSLog(@"最终获取到的数据 对下面的数据 进行解析 characteristic uuid:%@  value:%@",[NSString stringWithFormat:@"%@",descriptor.UUID],descriptor.value);
}
#pragma =======================================================================================================================================================================================================================================================================


#pragma mark -----通知------
////设置通知
-(void)notifyCharacteristic:(CBPeripheral *)peripheral
             characteristic:(CBCharacteristic *)characteristic{
    //设置通知，数据通知会进入：didUpdateValueForCharacteristic方法
    NSLog(@"1111");
    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    
}

//取消通知
-(void)cancelNotifyCharacteristic:(CBPeripheral *)peripheral
                   characteristic:(CBCharacteristic *)characteristic{
    
    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
}


-(void)appDidEnterBackground:(NSNotification *)_notification
{
//        [AppUtilities showBackgroundNotification:[NSString stringWithFormat:@"You are still connected to %@ peripheral. It will collect data also in background.",connectedPeripheral.name]];
}

-(void)appDidBecomeActiveBackground:(NSNotification *)_notification
{
   // [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

#pragma mark--------发送数据给 蓝牙端
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    if (error) {
        NSLog(@"写数据 错误的原因 ＝＝ %@",[error localizedDescription]);
    }else{
        NSLog(@"发送数据成功");
    }
    //第一个参数  所写的 数据  第二个参数  所要写入的 特征  第三个参数  类型
//    [self.diccoverPeripheral writeValue:<#(nonnull NSData *)#> forCharacteristic:<#(nonnull CBCharacteristic *)#> type:CBCharacteristicWriteWithResponse];
}

@end
