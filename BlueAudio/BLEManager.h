//
//  BLEManager.h
//  BlueAudio
//
//  Created by 姚晓丙 on 2018/6/6.
//  Copyright © 2018年 姚晓丙. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEManager : NSObject

+ (instancetype)sharedManager;
- (void)scanPeripherals;
- (void)connectToPeripheral;

@end
