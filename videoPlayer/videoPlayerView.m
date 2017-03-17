//
//  videoPlayerView.m
//  videoPlayer
//
//  Created by BO on 17/3/15.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import "videoPlayerView.h"
#import <Masonry/Masonry.h>
#import "AvplayerV.h"
#import "UIDevice+XJDevice.h"
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
@interface videoPlayerView ()
{
//    CGRect oriFrame;
}
@property (assign,nonatomic)CGRect          oriFrame;
@property (strong,nonatomic)AvplayerV     * vnaPlayer;
/** 上部视图 */
@property (strong,nonatomic)UIView        * topV;
/** 下部视图 */
@property (strong,nonatomic)UIView        * bottomV;
/** 视频标题 */
@property (strong,nonatomic)UILabel       * titleslab;
/** 返回按钮 */
@property (strong,nonatomic)UIButton      * backBtn;
/** 开始 暂停按钮 */
@property (strong,nonatomic)UIButton      * playOrPauseBtn;
/** 滑块 拖动播放进度 */
@property (strong,nonatomic)UISlider      * playSlider;
/** 缓存进度 */
@property (strong,nonatomic)UIProgressView* cacheProgress;
/** 当前播放的时间 一直刷新 */
@property (strong,nonatomic)UILabel       * currentTimelab;
/** 总共的时间 只需赋值一次 / */
@property (strong,nonatomic)UILabel       * totalTimelab;
/** 全屏按钮 */
@property (strong,nonatomic)UIButton      * fullscreenBtn;
/** 视频总时间 */
@property (assign,nonatomic) CGFloat        totalT;
/** 当前时间 */
@property (assign,nonatomic) CGFloat        currentT;
/** 缓存进度 % 的值 */
@property (assign,nonatomic) CGFloat        cacheT;
/** 是否以小时计数 */
@property (assign,nonatomic)BOOL            isHour;
/** 是否已经准备播放 */
@property (assign,nonatomic)BOOL          isReadyToPlay;
/** 是否正在播放 */
@property (assign,nonatomic)BOOL          isAlreadyPlay;
/** 是否全屏 */
@property (assign,nonatomic)BOOL          isFullScreen;

@end

@implementation videoPlayerView

-(instancetype)initWithFrame:(CGRect)frame andvideoURLstr:(NSString *)videoURLstr
{
    if (self = [super initWithFrame:frame]) {
        if (videoURLstr != nil) {
            _oriFrame = frame;
            AvplayerV * playV = [[AvplayerV alloc]initWithFrame:frame andURLstr:videoURLstr];
            [self addSubview:playV];
             self.vnaPlayer = playV;
            [self setUpUI];
            [self playerBlock];
        }
    }
    return  self;
}
-(void)setUpUI
{   WS(weakSelf);
    /** 添加手势 出现播放按钮 */
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(videoPlayBtnShow)];
    [self addGestureRecognizer:tap];
    
    UIButton * playPBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playPBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playPBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [playPBtn addTarget:self action:@selector(PlayOrPauseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playPBtn];
    [playPBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(144, 92));
        make.center.mas_equalTo(weakSelf);
    }];
    self.playOrPauseBtn = playPBtn;
    
    UIView * videoTopv = [[UIView alloc]init];
    videoTopv.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self addSubview:videoTopv];
    [videoTopv mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(weakSelf).with.offset(0);
         make.left.right.equalTo(weakSelf);
         make.height.equalTo(weakSelf.mas_height).multipliedBy(0.15);
    }];
    self.topV = videoTopv;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"go_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(BackBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [videoTopv addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(videoTopv).offset(10);
        make.centerY.mas_equalTo(videoTopv);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    UILabel * tempTlab = [[UILabel alloc]init];
    [tempTlab setText:@"卡哇伊的小姑娘"];
    tempTlab.textColor = [UIColor whiteColor];
    tempTlab.font = [UIFont systemFontOfSize:15.0];
    [videoTopv addSubview:tempTlab];
    [tempTlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn).offset(25);
        make.centerY.mas_equalTo(videoTopv);
        make.size.mas_equalTo(CGSizeMake(150, 25));
        
    }];
    self.titleslab = tempTlab;
    
    
    UIView * videoBottomv = [[UIView alloc]init];
    videoBottomv.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    [self addSubview:videoBottomv];
    [videoBottomv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakSelf);
        make.bottom.equalTo(weakSelf).offset(0);
        make.height.mas_equalTo(weakSelf.mas_height).multipliedBy(0.15);
        
    }];
    self.bottomV = videoBottomv;
    
    UILabel *currentlab = [[UILabel alloc]init];
    currentlab.text = @"00.00.00";
    currentlab.textColor = [UIColor whiteColor];
    currentlab.font = [UIFont systemFontOfSize:15.0];
    [videoBottomv addSubview:currentlab];
    [currentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(videoBottomv).offset(10);
        make.centerY.mas_equalTo(videoBottomv);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(25);
    }];
    self.currentTimelab = currentlab;
    
    
    UIButton * tempScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tempScreenBtn setImage:[UIImage imageNamed:@"big"] forState:UIControlStateNormal];//初始状态是小的 提示大
    [tempScreenBtn setImage:[UIImage imageNamed:@"small"] forState:UIControlStateSelected];
    [tempScreenBtn addTarget:self action:@selector(fullscreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoBottomv addSubview:tempScreenBtn];
    [tempScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(videoBottomv).offset(-10);
        make.centerY.mas_equalTo(videoBottomv);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    self.fullscreenBtn = tempScreenBtn;
    
    
    UILabel * totallab = [[UILabel alloc]init];
    totallab.text = @"00.00.06";
    totallab.textColor = [UIColor whiteColor];
    totallab.font = [UIFont systemFontOfSize:15.0];
    [videoBottomv addSubview:totallab];
    [totallab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(tempScreenBtn).offset(-15);
        make.centerY.mas_equalTo(videoBottomv);
        make.size.mas_equalTo(CGSizeMake(75, 25));
    }];
    self.totalTimelab = totallab;
    
    UIProgressView * progress = [[UIProgressView alloc]init];
     //甚至进度条的风格颜色值，默认是蓝色的
    // _progressView.progressTintColor=[UIColor redColor];
     
     //表示进度条未完成的，剩余的轨迹颜色,默认是灰色
    // _progressView.trackTintColor =[UIColor blueColor];
    [progress setProgressViewStyle:UIProgressViewStyleDefault];//设置默认样式
    [videoBottomv addSubview:progress];
    [progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leftMargin.mas_equalTo(currentlab.mas_right).offset(15);
        make.rightMargin.mas_equalTo(totallab.mas_left).offset(-15);
        make.centerY.mas_equalTo(videoBottomv);
    }];
    self.cacheProgress = progress;
    
    
    UISlider * slider = [[UISlider alloc]init];
    UIGraphicsBeginImageContextWithOptions((CGSize){1,1}, NO, 0.0f);
    UIImage *transparentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [slider setThumbImage:[UIImage imageNamed:@"icon_progress"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:transparentImage forState:UIControlStateNormal];
    [slider setMaximumTrackImage:transparentImage forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(playSliderChangeValueAction:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(playSliderTouchAction:) forControlEvents:UIControlEventTouchUpInside];
    [videoBottomv addSubview:slider];
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leftMargin.mas_equalTo(currentlab.mas_right).offset(15);
       make.rightMargin.mas_equalTo(totallab.mas_left).offset(-15);
       make.centerY.mas_equalTo(progress);
       
    }];
    self.playSlider = slider;
    
}

#pragma mark - PlayerBlock
/** 播放器监听代码块 */
-(void)playerBlock
{  WS(weakSelf);
    self.vnaPlayer.PlaySuccessBlock = ^{
     //表示准备成功
        weakSelf.isReadyToPlay = YES;
    };
    
    self.vnaPlayer.playFailBlock = ^(NSString * failReason){
        //获取失败的原因
    };
    self.vnaPlayer.currentTimeBlock=^(CGFloat current){
        weakSelf.currentT = current;
    };
    self.vnaPlayer.TotalTimeBlock = ^(CGFloat totalT){
        weakSelf.totalT = totalT;
    };
    self.vnaPlayer.cacheTimeBlock = ^(CGFloat cacheT){
        weakSelf.cacheT = cacheT;
    };
    
//    __weak typeof(self)weakself = self;
   
    
    self.vnaPlayer.OrientationChange = ^(UIDeviceOrientation orient){
        if (orient == UIDeviceOrientationPortrait) {//竖屏状态
            weakSelf.frame = weakSelf.oriFrame;
            weakSelf.vnaPlayer.frame = weakSelf.oriFrame;
            weakSelf.fullscreenBtn.selected = NO;
        }else if(orient == UIDeviceOrientationLandscapeLeft||
                 orient == UIDeviceOrientationLandscapeRight){
            weakSelf.frame = [UIScreen mainScreen].bounds;
            weakSelf.vnaPlayer.frame = weakSelf.frame;
            weakSelf.fullscreenBtn.selected = YES;
        }
    };
    /** 播放结束了... */
    self.vnaPlayer.playEndBlock = ^(){
       //播放结束
      [weakSelf.vnaPlayer.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
          [weakSelf.playSlider setValue:0.0f animated:YES];
           weakSelf.isAlreadyPlay = NO;
           weakSelf.playOrPauseBtn.selected = NO;
      }];
    };
    
}

#pragma mark - action

/**
 播放或者暂停

 @param playBtn pl
 */
-(void)PlayOrPauseBtnAction:(UIButton *)playBtn
{
    playBtn.selected = self.isAlreadyPlay;
    if (self.isAlreadyPlay) {//表示暂停状态
//        playBtn.selected = NO;
        //isReadyForDisplay
        self.isAlreadyPlay = NO;
        [self.vnaPlayer.player play];
    }else {//正在播放
        //if(self.vnaPlayer.player.rate == 1.0)
//        playBtn.selected = YES;
        self.isAlreadyPlay = YES;
        [self.vnaPlayer.player pause];
    }
    WS(weakSelf);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        playBtn.alpha = 0.0;
        weakSelf.topV.alpha = 0.0;
        weakSelf.bottomV.alpha = 0.0;
    });
    
}
/** 返回按钮点击事件 */
-(void)BackBtnAction
{
    
}

/**
 全屏 半屏 动作

 @param fullBtn full
 */
-(void)fullscreenAction:(UIButton *)fullBtn
{
//    WS(weakSelf);
    fullBtn.selected = !fullBtn.selected;
    if (!_isFullScreen) {//如果不是全屏
        self.isFullScreen = YES;
        [UIDevice setOrientation:UIInterfaceOrientationPortrait];
        self.frame = _oriFrame;
        self.vnaPlayer.frame = _oriFrame;
        [self updateConstraintsIfNeeded];
    }else{
        self.isFullScreen = NO;
        [UIDevice setOrientation:UIInterfaceOrientationLandscapeRight];
        self.vnaPlayer.frame = self.window.bounds;
        self.frame = self.window.bounds;
     
    }
    
}
/** 播放按钮的显示 */
-(void)videoPlayBtnShow
{
    WS(weakSelf);
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.playOrPauseBtn.alpha = 1.0;
        weakSelf.topV.alpha = 1.0;
        weakSelf.bottomV.alpha = 1.0;
    }];
    
}
/** 滑块拖动时 */
-(void)playSliderChangeValueAction:(UISlider*)slider
{
    if (self.SliderisDrag) {
        self.SliderisDrag(YES);//正在拖动，停止定时器更新进度,否则定时器更新的进度和拖动的进度会有冲突...
    }
    self.isAlreadyPlay = NO;
    self.playOrPauseBtn.selected = NO;
//    /** 让播放器移动到指定距离 */
    [self.vnaPlayer playerSeekToTimeWithSecond:slider.value];
//    [self PlayOrPauseBtnAction:self.playOrPauseBtn];
}
/** 完成拖动 */
-(void)playSliderTouchAction:(UISlider *)slider
{
//    /** 让播放器移动到指定距离 */
//    [self.vnaPlayer playerSeekToTimeWithSecond:slider.value];
//////    self.isAlreadyPlay = NO;
    [self PlayOrPauseBtnAction:self.playOrPauseBtn];
}
#pragma mark - set
-(void)setTotalT:(CGFloat)totalT
{
    _totalT = totalT;
    NSString * totalTStr = [self PlayerTimeStyle:totalT];
    if (self.isHour) {
       self.totalTimelab.text = totalTStr;
    }else{
        self.totalTimelab.text = [NSString stringWithFormat:@"00:%@",totalTStr];
    }
    /** 设置滑块的最大滑动范围 */
    self.playSlider.maximumValue = totalT;
    
}
/** 这里是一秒赋值一次 ，起到了刷新的作用. */
-(void)setCurrentT:(CGFloat)currentT
{
    _currentT = currentT;
    [self.playSlider setValue:currentT animated:YES];
    NSString * currentStr = [self PlayerTimeStyle:currentT];
    if (self.isHour) {
     self.currentTimelab.text = currentStr;
    }else{
        self.currentTimelab.text = [NSString stringWithFormat:@"00:%@",currentStr];
    }
    
}
-(void)setCacheT:(CGFloat)cacheT
{
    _cacheT = cacheT;
    [self.cacheProgress setProgress:cacheT animated:YES];
}

#pragma mark - method
//定义视屏时长样式
- (NSString *)PlayerTimeStyle:(CGFloat)time{
    
//    int seconds = time % 60;
//    int minutes = (totalSeconds / 60) % 60;
//    int hours = totalSeconds / 3600;
//    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (time/3600>1) {
        _isHour = YES;
        [formatter setDateFormat:@"HH:mm:ss"];
    }else{
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showTimeStyle = [formatter stringFromDate:date];
    return showTimeStyle;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self updateConstraintsIfNeeded];
    
}
@end
