//
//  BLEManager.m
//  BlueAudio
//
//  Created by 姚晓丙 on 2018/6/6.
//  Copyright © 2018年 姚晓丙. All rights reserved.
//

#import "BLEManager.h"
#import <CoreBluetooth/CoreBluetooth.h>



@interface BLEManager ()<CBPeripheralDelegate, CBCentralManagerDelegate>

@property (strong, nonatomic) CBCentralManager *centerManager;

@property (strong, nonatomic) CBPeripheral *peripheral;

@end

@implementation BLEManager

+ (instancetype)sharedManager
{
    static BLEManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BLEManager new];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        _centerManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    }
    return self;
}

- (void)scanPeripherals
{
    [self.centerManager stopScan];
    
    if (self.centerManager.state == CBManagerStatePoweredOn) {
        [self.centerManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey: @NO}];
    } else {
        NSLog(@"手机蓝牙异常，请打开");
    }
}


- (void)connectToPeripheral
{
    if (self.centerManager.isScanning) {
        [self.centerManager stopScan];
    }
    
    if (!self.peripheral) {
        NSLog(@"没有连接的外部设备");
        return;
    }
    
    [self.centerManager connectPeripheral:self.peripheral options:nil];
}


#pragma mark - CBCentralManagerDelegate


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOn:
            NSLog(@"开机，正常");
            [self scanPeripherals];
            break;
        default:
            NSLog(@"手机蓝牙异常，请打开");
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    if ([peripheral.name hasPrefix:@"TOPPERS"]) {
        NSLog(@"peripheral = %@",peripheral);
        peripheral.delegate = self;
        self.peripheral = peripheral;
        [self.centerManager stopScan];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"连接 %@，成功",peripheral.name);
    [self.peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    self.peripheral = nil;
    NSLog(@"断开连接");
}


#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error
{
    NSArray *services = peripheral.services;
    for (CBService *service in services) {
        NSLog(@"service = %@",service);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error;
{
    NSArray *characteristics = service.characteristics;
    for (CBCharacteristic *characteristic in characteristics) {
        NSLog(@"characteristic = %@",characteristic);
        
        if (characteristic.properties & CBCharacteristicPropertyRead) {
            [self.peripheral readValueForCharacteristic:characteristic];
        }

        if (characteristic.properties & CBCharacteristicPropertyNotify || characteristic.properties & CBCharacteristicPropertyIndicate) {
            [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error;
{
    if (error) {
        NSLog(@"error = %@,%s",error,__FUNCTION__);
    }
    
    if (characteristic.isNotifying) {
        NSLog(@"开始监听 %@",characteristic);
    }
    
    
//    NSLog(@"data = %@",characteristic.value);
}


- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"error = %@,%s",error,__FUNCTION__);
    }
    
    NSLog(@"data = %@",characteristic.value);
    Byte *byes = characteristic.value.bytes;
    NSLog(@"%s",byes);

}




@end
