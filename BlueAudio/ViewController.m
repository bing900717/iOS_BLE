//
//  ViewController.m
//  BlueAudio
//
//  Created by 姚晓丙 on 2018/6/6.
//  Copyright © 2018年 姚晓丙. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BLEViewController.h"

@interface ViewController ()
@property (nonatomic) AVAudioRecorder * audioRecorder;
@property (nonatomic) AVAudioPlayer *audioPlayer;

@end

@implementation ViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)bleAction:(id)sender {
    
    BLEViewController *vc = [BLEViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initSession];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotification:) name:AVAudioSessionRouteChangeNotification object:[AVAudioSession sharedInstance]];
//
//
//
////    CFDictionaryRef descDictRef = nil;
////
////    UInt32 refSize = sizeof(descDictRef);
////
////   OSStatus status = AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &refSize, &descDictRef);
////
////    NSLog(@"descDictRef = %@",descDictRef);
//
//
//
//
//    NSArray *inputs = [[AVAudioSession sharedInstance] availableInputs];
//    NSLog(@"inputs = %@",inputs);
    
    
    
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



- (void)receiveNotification:(NSNotification *)notification
{
    
//    NSDictionary *userInfo = notification.userInfo;
//    AVAudioSessionRouteDescription *previous = userInfo[@"AVAudioSessionRouteChangePreviousRouteKey"];
//
//
//    for (AVAudioSessionPortDescription *port in previous.inputs) {
//        NSLog(@"input\n type = %@,name = %@,uid = %@",port.portType,port.portName,port.UID);
//    }
//
//    for (AVAudioSessionPortDescription *port in previous.outputs) {
//        NSLog(@"output\n type = %@,name = %@,uid = %@",port.portType,port.portName,port.UID);
//
//    }
    
    
    
}


- (IBAction)record:(id)sender {
    
    [self initSession];
    NSLog(@"FlyElephant-startRecording");
    NSError *error = nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:[self recordURL] settings:[self audioRecordingSettings] error:&error];
    if (error) {
        NSLog(@"record error = %@",error);
    }
    self.audioRecorder.meteringEnabled = YES;
    if ([self.audioRecorder prepareToRecord] == YES){
        self.audioRecorder.meteringEnabled = YES;
        [self.audioRecorder record];
    }else {
        NSLog(@"FlyElephant--初始化录音失败");
    }
    
}

- (IBAction)stopRecording:(id)sender {

    [self.audioRecorder stop];

}
- (IBAction)play:(id)sender {
    NSLog(@"FlyElephant-playRecording");
    [self initSession];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[self recordURL] error:&error];
    if (error) {
        NSLog(@"play error = %@",error);
    }
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
    NSLog(@"FlyElephant-playing");
    

    
}
- (IBAction)stopPlaying:(id)sender {
    [self.audioPlayer stop];
}

- (NSDictionary *)audioRecordingSettings{
    
    NSDictionary *result = nil;
    
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
    // [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleLossless] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数 1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数 8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    result = [NSDictionary dictionaryWithDictionary:recordSetting];
    return result;
}

- (NSURL *)recordURL
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    return url;
}


- (void)initSession
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    if (session.isInputAvailable) {
        NSError *error;
        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&error];
        if (error) {
            NSLog(@"session error = %@",error);
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
