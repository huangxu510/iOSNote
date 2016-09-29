//
//  MainViewController.m
//  SY_CheShi
//
//  Created by 钱学明 on 16/1/26.
//  Copyright © 2016年 钱学明. All rights reserved.
//

#import "MainViewController.h"
#import "SyTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Model.h"

#define CellHeight 50

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate,CBPeripheralDelegate>
{
    //nav
    UIBarButtonItem * _leftBtn;   //导航左键
    UIBarButtonItem * _rightBtn;  //导航右键
    //蓝牙
    NSString * blueToothName;     //蓝牙 名称
    BOOL isWriteWithoutResponse;  //是否 这种发送方式
    BOOL isLinkSuc;               //是否 连接成功
    BOOL isLinked;                //是否 已经连接
    BOOL isStop;                  //是否 人为停止
    
    UITableView * _tableView;     //界面 显示
    NSIndexPath * _indexPath;     //记录 点击 tableview 的 cell
}

@property (nonatomic, strong) NSTimer * timer;      //搜索 属性  定时器
@property (nonatomic, strong) NSTimer * scanPeripheralTimer;         //搜索 周边设备 定时器
@property (nonatomic, strong) CBCentralManager * manager;            //中心
@property (nonatomic, strong) CBPeripheral * diccoverPeripheral;
@property (nonatomic, strong) CBPeripheral * perip;
@property (nonatomic, strong) NSMutableArray * peripheralMarr; //接收 外设 的数组
@property (nonatomic, strong) CBService * servi;               //当前选中的 外设 的service

@end

@implementation MainViewController

//外设数组  懒加载
-(NSMutableArray *)peripheralMarr{
    if (_peripheralMarr == nil) {
        _peripheralMarr = @[].mutableCopy;
    }
    return _peripheralMarr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"蓝牙测试";
    //是否连接成功
    isLinkSuc = NO;
    //是否 人为停止 设置为否
    isStop = NO;
    //添加导航 btn
    [self setNav];
}
-(void)setNav{
    //搜索外围 所有 蓝牙设备  导航左键
    _leftBtn = [[UIBarButtonItem alloc]initWithTitle:@"搜索" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtn_touch)];
    self.navigationItem.leftBarButtonItem = _leftBtn;
}
-(void)setTableView{
    //添加 tableview  展示
    _tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark-----------nav-------------
-(void)leftBtn_touch{
    //链接蓝牙   外围设备 数组 清空  防止多次 点击 重复 添加
    self.peripheralMarr = @[].mutableCopy;
    dispatch_queue_t centralQueue = dispatch_queue_create("no.nordicsemi.ios.nrftoolbox", DISPATCH_QUEUE_SERIAL);
    _manager = [[CBCentralManager alloc]initWithDelegate:self queue:centralQueue];
    if (!_scanPeripheralTimer) {
        //计时器  设定  多久  扫描一次
        _scanPeripheralTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scanForPeripherals) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_scanPeripheralTimer forMode:NSDefaultRunLoopMode];
    }
    if (_scanPeripheralTimer && !_scanPeripheralTimer.valid) {
        [_scanPeripheralTimer fire];
    }
}
- (void)scanForPeripherals{
     NSLog(@"开始搜索周边设备");
    if (_manager.state == CBCentralManagerStateUnsupported) {
        //设备不支持蓝牙
        NSLog(@"设备不支持蓝牙");
    }else {//设备支持蓝牙连接
        if (_manager.state == CBCentralManagerStatePoweredOn) {
            //蓝牙开启状态时 搜索周边设备
            [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:[NSNumber numberWithBool:NO]}];
        }
    }
    //已经连接蓝牙 成功 后 的设备 的 rssi 在readRSSI后 会自动执行 下面的 协议方法
    //-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"111");
        [self.perip readRSSI];
//    });
    
}
-(void)rightBtn_touch{
    //是否 人为停止 设为 是
    isStop = YES;
    //是否 连接成功 设为 否
    isLinkSuc = NO;
    //断开 中心与外设的连接
    if (self.perip != nil) {
        [_manager cancelPeripheralConnection:self.perip];
    }
    //导航右键 消失
    self.navigationItem.rightBarButtonItem = nil;
    //tableview 字体颜色 变回黑色
    SyTableViewCell * cell = [_tableView cellForRowAtIndexPath:_indexPath];
    cell.titleLable.textColor = [UIColor blackColor];
    [self.peripheralMarr removeAllObjects];
   

    //界面刷新
    [_tableView reloadData];
}
#pragma mark---------蓝牙-----------
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
#pragma mark--------central中心协议-------------
//设备成功打开的委托方法，并在此委托方法中扫描设备
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
//    if (central.state != CBCentralManagerStatePoweredOn) {
//        return;
//    }
//    NSLog(@"开始搜索周边设备");
//    // 第一个参数nil就是扫描周围所有的外设
//    //第二个参数options的意思是否允许中央设备多次收到曾经监听到的设备的消息，这样来监听外围设备联接的信号强度，以决定是否增大广播强度，为YES时会多耗电
//    
//    [_manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
    switch (central.state) {
        case CBCentralManagerStatePoweredOff:
            NSLog(@"CBCentralManagerStatePoweredOff");
            break;
        case CBCentralManagerStatePoweredOn:
            NSLog(@"CBCentralManagerStatePoweredOn");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"CBCentralManagerStateResetting");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"CBCentralManagerStateUnauthorized");
            break;
        case CBCentralManagerStateUnknown:
            NSLog(@"CBCentralManagerStateUnknown");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"CBCentralManagerStateUnsupported");
            break;
        default:
            break;
    }
}
//扫描到设备会进入方法
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    //RSSI == 信号强度值  advertisementData == 外设 发出的广告 数据
    //如果 搜索到的外设 非空 则用 model 来接取 外设以及rssi
    if (peripheral == nil) {
        [_peripheralMarr removeAllObjects];
    }
    if (peripheral.name != nil) {
        Model * model = [[Model alloc]init];
        model.peripheral = peripheral;
        model.num = [RSSI intValue];
        //如果 外设数组数量为0 则 直接将 该 model 添加到 外设数组中
        //如果 外设数组数量不为0 则 用遍历数组 用外设的名称 进行判断 是否 存在于该数组中
        //如果 外设名称相同  则 只修改 该外设 所对应的 rssi
        //如果 外设名称不同  则 将此外设 加入到外设数组中
        if (_peripheralMarr.count == 0) {
            [_peripheralMarr addObject:model];
        }else{
            BOOL ishave = NO;
            for (Model * mo in _peripheralMarr) {
                if ([mo.peripheral.name isEqualToString:model.peripheral.name]) {
                    mo.num = model.num;
                    ishave = YES;
                    break;
                }else{
                    
                }
            }
            if (ishave == NO) {
                [_peripheralMarr addObject:model];
            }
        }
    }else{
        [self.peripheralMarr removeAllObjects];
    }
    //NSLog(@">>>搜索到的外设数组 包含 == %@",_peripheralMarr);
    //异步加载 界面 如果 tableview 为空 则 创建 否则 刷新页面
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_tableView == nil) {
            [self setTableView];
        }else{
            [_tableView reloadData];
        }
    });
}
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@">>>连接到名称为（%@）的设备-成功",peripheral.name);
    //因项目 需要  即使连接 成功后 也继续 进行搜索 其他设备
    //[self.manager stopScan];
    //是否连接成功  设置 为 是
    isLinkSuc = YES;
    //设置外设的代理
    peripheral.delegate = self;
    //告诉外围设备，谁与外围设备连接
    [peripheral discoverServices:nil];
}
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>连接到名称为（%@）的设备-失败,原因:%@",[peripheral name],[error localizedDescription]);
    //是否连接成功 设置 为 否
    isLinkSuc = NO;
    [self cleanUp];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@">>>外设连接断开连接 %@: %@\n", [peripheral name], [error localizedDescription]);
    //被赋值 的 外围 设备 设置 为空
    self.diccoverPeripheral = nil;
    //是否 人为停止  如果 是（手动断开连接） 则是否连接成功 设为否 页面刷新  如不是人为断开 则 重新自动连接
    if (isStop == YES) {
        //是否断开连接  设为 否
        isLinkSuc = NO;
        //是否停止  设为 是
        isStop = NO;
        
    }else{
        [self startScan:peripheral];
    }
}

#pragma mark--------连接成功后 执行以下协议--------------
-(void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
//    if (peripheral.name != nil) {
//        Model * model = [[Model alloc]init];
//        model.peripheral = peripheral;
//        model.num = [RSSI intValue];
//        for (Model * mo in _peripheralMarr) {
//            if ([mo.peripheral.name isEqualToString:model.peripheral.name]) {
//                mo.num = model.num;
//                NSLog(@"已连接的 外设 当前 rssi ＝＝ %d",mo.num);
//                SyTableViewCell * cell = [_tableView cellForRowAtIndexPath:_indexPath];
//                cell.rssiLable.text = [NSString stringWithFormat:@"%d",mo.num];
//                [_tableView reloadData];
//                break;
//            }else{
//                NSLog(@"222");
//            }
//        }
//    }
    if (peripheral.name != nil) {
        Model * model = [[Model alloc]init];
        model.peripheral = peripheral;
        model.num = [RSSI intValue];
        //如果 外设数组数量为0 则 直接将 该 model 添加到 外设数组中
        //如果 外设数组数量不为0 则 用遍历数组 用外设的名称 进行判断 是否 存在于该数组中
        //如果 外设名称相同  则 只修改 该外设 所对应的 rssi
        //如果 外设名称不同  则 将此外设 加入到外设数组中
        if (_peripheralMarr.count == 0) {
            [_peripheralMarr addObject:model];
        }else{
            BOOL ishave = NO;
            for (Model * mo in _peripheralMarr) {
                if ([mo.peripheral.name isEqualToString:model.peripheral.name]) {
                    mo.num = model.num;
                    ishave = YES;
                    break;
                }else{
                    
                }
            }
            if (ishave == NO) {
                [_peripheralMarr addObject:model];
            }
        }
    }else{
        [self.peripheralMarr removeAllObjects];
    }
    //NSLog(@">>>搜索到的外设数组 包含 == %@",_peripheralMarr);
    //异步加载 界面 如果 tableview 为空 则 创建 否则 刷新页面
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_tableView == nil) {
            [self setTableView];
        }else{
            [_tableView reloadData];
        }
    });
}
//扫描到Services
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSLog(@">>>扫描到服务：%@",peripheral.services);
    //异步 因为连接成功 则 创建 导航右键 同时 是否已经连接 设为 是  刷新 tableview 页面
    dispatch_async(dispatch_get_main_queue(), ^{
        if (isLinkSuc == YES) {
            _rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"停止" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtn_touch)];
            self.navigationItem.rightBarButtonItem = _rightBtn;
            isLinked = YES;
            SyTableViewCell * cell = [_tableView cellForRowAtIndexPath:_indexPath];
            cell.titleLable.textColor = [UIColor redColor];
        }
    });
    if (isLinked == YES) {
        [_tableView reloadData];
    }
    if (error){
        NSLog(@">>>服务的名字： %@ with 错误原因: %@", peripheral.name, [error localizedDescription]);
        [self cleanUp];
        return;
    }
    if (!self.timer) {
        //计时器  设定  多久  扫描一次
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(discoverServices:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    //    for (CBService *service in peripheral.services) {
    //        [peripheral discoverCharacteristics:nil forService:service];
    //    }
}
//扫描到Characteristics
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error){
        NSLog(@"服务的错误原因for %@ with error: %@", service.UUID, [error localizedDescription]);
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
#pragma mark------------向外设 发送 数据 写在 下面--------------
    //每进入 此方法 一次  都会给 服务 重新 赋值
    _servi = service;
#pragma mark=================================================
}
#pragma ==========获取蓝牙数据===========
//获取的charateristic的值
-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    //打印出characteristic的UUID和值
    //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
    NSLog(@"服务: == %@ ,特征 uuid:== %@  value:== %@",peripheral.services,characteristic.UUID,characteristic.value);
    // Scanner uses other queue to send events. We must edit UI in the main queue
}
//搜索到Characteristic的Descriptors
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    [peripheral readRSSI];
    if (error) {
        NSLog(@"错误 characteristics: %@", [error localizedDescription]);
        return;
    }
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
#pragma mark -----通知  此 项目中 暂时 无用 ------
//设置通知
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
-(void)appDidEnterBackground:(NSNotification *)_notification{
//            [AppUtilities showBackgroundNotification:[NSString stringWithFormat:@"You are still connected to %@ peripheral. It will collect data also in background.",connectedPeripheral.name]];
}
-(void)appDidBecomeActiveBackground:(NSNotification *)_notification{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
#pragma mark--------发送数据给 蓝牙端 官方提供的 方法----------
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(NSError *)error{
    if (error) {
        NSLog(@"写数据 错误的原因 ＝＝ %@",[error localizedDescription]);
    }else{
        NSLog(@"发送数据成功");
    }
    //第一个参数  所写的 数据  第二个参数  所要写入的 特征  第三个参数  类型
    //[self.diccoverPeripheral writeValue:(nonnull NSData *) forCharacteristic:(nonnull CBCharacteristic *) type:CBCharacteristicWriteWithResponse];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark-----------tableview----------
//tableview 留白问题
- (void) viewDidLayoutSubviews {
    CGRect viewBounds = self.view.bounds;
    CGFloat topBarOffset = self.topLayoutGuide.length;
    viewBounds.origin.y = topBarOffset * -1;
    self.view.bounds = viewBounds;
}
//section为 1
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
//row为外设数组 的 数量 当数组 数量为0 时 则 代表 没有搜索到 外设 返回1个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.peripheralMarr.count == 0) {
        return 1;
    }else{
        return self.peripheralMarr.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //自定义 SyTableViewCell
    SyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (cell == nil) {
        cell = [[SyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellID"];
        //cell上 需要添加的 任何 控件 可在 addUI方法中 实现
        [cell addUI];
    }
    if (self.peripheralMarr.count == 0) {
        cell.titleLable.text = @"没有发现可用设备";
        cell.rssiLable.text = nil;
    }else{
        Model * model = self.peripheralMarr[indexPath.row];
        cell.titleLable.text = model.peripheral.name;
        cell.rssiLable.text = [NSString stringWithFormat:@"%d",model.num];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
//cell高度 为 50；
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CellHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.peripheralMarr.count == 0) {
        
    }else{
        Model * m = self.peripheralMarr[indexPath.row];
        self.perip = m.peripheral;
        blueToothName = m.peripheral.name;
        if (isLinkSuc == NO) {
            if (self.navigationItem.rightBarButtonItem != nil) {
            }else{
                if (self.peripheralMarr.count == 0) {
                }else{
                    _indexPath = indexPath;
                    UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"是否连接该蓝牙" message:[NSString stringWithFormat:@"%@",blueToothName] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction * aa = [UIAlertAction actionWithTitle:@"连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self startScan:self.perip];
                    }];
                    UIAlertAction * aa1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                    }];
                    [ac addAction:aa];
                    [ac addAction:aa1];
                    [self presentViewController:ac animated:YES completion:^{
                    }];
                }
            }
        }else{
            if (_indexPath == indexPath) {
                UIAlertController * ac = [UIAlertController alertControllerWithTitle:@"请点击发送方式" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * ac1 = [UIAlertAction actionWithTitle:@"REQ" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //REQ === WriteWithResponse
                    for (CBService *service in self.perip.services) {
                        [self.perip discoverCharacteristics:nil forService:service];
                    }
                    for(int i=0; i < _servi.characteristics.count; i++) {
                        CBCharacteristic *c = [_servi.characteristics objectAtIndex:i];
                        Byte dataArr[128];
                        for (int i = 0; i < 128; i++) {
                            dataArr[i] = 0x31;
                        }
                        NSData * myData = [NSData dataWithBytes:dataArr length:128];
                        [self.perip writeValue:myData forCharacteristic:c type:CBCharacteristicWriteWithResponse];
                    }
                }];
                UIAlertAction * ac2 = [UIAlertAction actionWithTitle:@"COM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    //COM === WriteWithoutResponse
                    for (CBService *service in self.perip.services) {
                        [self.perip discoverCharacteristics:nil forService:service];
                    }
                    for(int i=0; i < _servi.characteristics.count; i++) {
                        CBCharacteristic *c = [_servi.characteristics objectAtIndex:i];
                        Byte dataArr[128];
                        for (int i = 0; i < 128; i++) {
                            dataArr[i] = 0x31;
                        }
                        NSData * myData = [NSData dataWithBytes:dataArr length:128];
                        [self.perip writeValue:myData forCharacteristic:c type:CBCharacteristicWriteWithoutResponse];
                    }
                }];
                UIAlertAction * ac3 = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                }];
                [ac addAction:ac1];
                [ac addAction:ac2];
                [ac addAction:ac3];
                [self presentViewController:ac animated:YES completion:^{
                }];
            }
        }
    }
}

@end
