//
//  BLEViewController.m
//  BlueAudio
//
//  Created by 姚晓丙 on 2018/6/6.
//  Copyright © 2018年 姚晓丙. All rights reserved.
//

#import "BLEViewController.h"
#import "BLEManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface BLEViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISwitch *powerOnSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *connectSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISwitch *connectClassicSwitch;


@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLEManager sharedManager] scanPeripherals];
    // Do any additional setup after loading the view from its nib.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [self.connectClassicSwitch setOn:[self isBleToothOutput]];
    
    [[MPRemoteCommandCenter sharedCommandCenter].togglePlayPauseCommand addTarget:self action:@selector(onTooglePlayPause:)];

    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)onTooglePlayPause:(id)sender
{
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)theEvent
{
    if (theEvent.type == UIEventTypeRemoteControl)
    {
        switch(theEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                //Insert code
                
                break;
            case UIEventSubtypeRemoteControlPlay:
                //Insert code
                NSLog(@"play");
                break;
            case UIEventSubtypeRemoteControlPause:
                // Insert code
                NSLog(@"pause");
                break;
            case UIEventSubtypeRemoteControlStop:
                //Insert code.
                NSLog(@"stop");
                break;
            default:
                return;
        }
    }
}




-(BOOL)isBleToothOutput

{
    
    AVAudioSessionRouteDescription *currentRount = [AVAudioSession sharedInstance].currentRoute;
    
    AVAudioSessionPortDescription *outputPortDesc = currentRount.outputs[0];
    
    if([outputPortDesc.portType isEqualToString:@"BluetoothA2DPOutput"]){
        
        NSLog(@"bluetooth name = %@",outputPortDesc.portName);
        NSLog(@"当前输出的线路是蓝牙输出，并且已连接");
        
        return YES;
        
    }else{
        
        NSLog(@"当前是spearKer输出");
        
        return NO;
        
    }
    
}




- (IBAction)scanPeripherals:(id)sender {
        
    [[BLEManager sharedManager] scanPeripherals];
}

- (IBAction)connectPeripheral:(id)sender {
    [[BLEManager sharedManager] connectToPeripheral];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
