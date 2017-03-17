//
//  ViewController.m
//  videoPlayer
//
//  Created by BO on 17/3/14.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import "ViewController.h"
#import "videoPlayerView.h"

@interface ViewController ()

@property (strong,nonatomic)AVPlayer * player;
@property (strong,nonatomic)AVPlayerItem * playerItem;
@property (strong,nonatomic)UILabel * testlab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //http://flv2.bn.netease.com/tvmrepo/2017/3/M/1/ECEIM9AM1/SD/ECEIM9AM1-mobile.mp4
    //http://vr.tudou.com/v2proxy/v2.m3u8?it=170010302&st=2
    videoPlayerView * playV = [[videoPlayerView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300) andvideoURLstr:@"http://vr.tudou.com/v2proxy/v2.m3u8?it=170010302&st=2"];
    [self.view addSubview:playV];


    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)BtnAction:(UIButton *)sender {
    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
