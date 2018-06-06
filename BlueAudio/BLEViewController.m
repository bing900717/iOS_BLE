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

@interface BLEViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISwitch *powerOnSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *connectSwitch;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation BLEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[BLEManager sharedManager] scanPeripherals];
    // Do any additional setup after loading the view from its nib.
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
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
