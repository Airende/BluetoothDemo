//
//  RDBluetoothViewController.m
//  BluetoothDemo
//
//  Created by airende on 2017/6/5.
//  Copyright © 2017年 airende. All rights reserved.
//

#import "RDBluetoothViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface RDBluetoothViewController ()<CBPeripheralDelegate,CBCentralManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIButton *bluetoothButton;

@property(nonatomic, strong) CBCentralManager *cManager;

@property(nonatomic, strong) CBPeripheral *peripheral;

@property(nonatomic, strong) NSMutableArray *peripheralsArray;//外部设备数组


@end

@implementation RDBluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupView];
    
}

- (void)setupData{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorInset = UIEdgeInsetsZero;
    self.tableview.tableFooterView = [UIView new];
    
}
- (void)setupView{
    _peripheralsArray = [NSMutableArray array];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _peripheralsArray.count;
}
- (IBAction)BeganSearchBluetooth:(UIButton *)sender {
    
    [self.cManager scanForPeripheralsWithServices:nil options:nil];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    CBPeripheral *peripheral = _peripheralsArray[indexPath.row];
    cell.textLabel.text = peripheral.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    _peripheral=_peripheralsArray[indexPath.row];
    //设定周边设备，指定代理者
    _peripheral.delegate = self;
    //连接设备
    [_cManager connectPeripheral:_peripheral
                        options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
}

#pragma mark - CBCentralManagerDelegate
//该方法用于告诉Central Manager，要开始寻找一个指定的服务了.不能在state非ON的情况下对我们的中心管理者进行操作,scanForPeripheralsWithServices方法中 sercices为空则会扫描所有的设备.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            NSLog(@"中心管理器状态未知");
            break;
        case CBCentralManagerStateResetting:
            NSLog(@"中心管理器状态重置");
            break;
        case CBCentralManagerStateUnsupported:
            NSLog(@"中心管理器状态不被支持");
            break;
        case CBCentralManagerStateUnauthorized:
            NSLog(@"中心管理器状态未被授权");
            break;
        case CBCentralManagerStatePoweredOff:
            NSLog(@"中心管理器状态电源关闭");
            break;
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"中心管理器状态电源开启");
            // 在中心管理者成功开启后开始搜索外设
            
            [self.cManager scanForPeripheralsWithServices:nil options:nil];
            // 搜索成功之后,会调用我们找到外设的代理方法 sercices为空则会扫描所有的设备
            // - (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI; //找到外设
            
        }
            break;
        default:
            break;
    }
}


/**
 扫描外部设备（扫描状态一直执行）

 @param central 中心设备
 @param peripheral 外部设备
 @param advertisementData 广告数据<广播中携带的一些信息>
 @param RSSI 信号质量
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI

{
    //NSLog(@"central = %@,peripheral = %@,advertisementData = %@,RSSI = %@",central,peripheral,advertisementData,RSSI);
    if(![_peripheralsArray containsObject:peripheral]){
        if (peripheral.name != nil) {
            [_peripheralsArray addObject:peripheral];
        }
    }
    [self.tableview reloadData];
}


/**
 蓝牙设备连接成功

 @param central 中心设备
 @param peripheral 外部设备
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
    NSLog(@"central = %@,peripheral = %@",central,peripheral);
    
    NSLog(@"%@",peripheral);
    
    // 设置设备代理
    [peripheral setDelegate:self];
    // 大概获取服务和特征
    [peripheral discoverServices:nil];
    
    //或许只获取你的设备蓝牙服务的uuid数组，一个或者多个
    //[peripheral discoverServices:@[[CBUUID UUIDWithString:@""],[CBUUID UUIDWithString:@""]]];
    
    NSLog(@"Peripheral Connected");
    
    [_cManager stopScan];
    
    NSLog(@"Scanning stopped");
    
}

/**
 蓝牙设备链接失败

 @param central 中心设备<自己的设备>
 @param peripheral 外部设备<连接设备>
 @param error 错误代码
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    
    NSLog(@"peripheral = %@ error = %@",peripheral,error);
    
}


/**
 特征获取

 @param peripheral <#peripheral description#>
 @param service <#service description#>
 @param error <#error description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    NSLog(@"服务：%@",service.UUID);
    // 特征
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        NSLog(@"%@",characteristic.UUID);
        //发现特征
        //注意：uuid 分为可读，可写，要区别对待！！！
        
        
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"你的特征uuid"]])
        {
            NSLog(@"监听：%@",characteristic);//监听特征
            //保存characteristic特征值对象
            //以后发信息也是用这个uuid
            
        }
        
        //当然，你也可以监听多个characteristic特征值对象
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"你的特征uuid"]])
        {
            //同样用一个变量保存，demo里面没有声明变量，要去声明
            //            _characteristic2 = characteristic;
            //            [peripheral setNotifyValue:YES forCharacteristic:_characteristic2];
            //            NSLog(@"监听：%@",characteristic);//监听特征
        }
    }
}

/**
 通过蓝牙获取到数据

 @param peripheral <#peripheral description#>
 @param characteristic <#characteristic description#>
 @param error <#error description#>
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;{
    if (error)
    {
        NSLog(@"Error updating value for characteristic %@ error: %@", characteristic.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"收到的数据：%@",characteristic.value);
    
}


- (CBCentralManager *)cManager{
    if (!_cManager) {
        _cManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue() options:nil];
    }
    return _cManager;
}

@end
