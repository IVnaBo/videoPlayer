//
//  AvplayerV.h
//  videoPlayer
//
//  Created by BO on 17/3/16.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
/** 把播放器的代码抽离 */
@interface AvplayerV : UIView
/** 界面更新时间ID */
@property (nonatomic, strong) id playbackTimeObserver;
@property (assign,nonatomic)BOOL            issuccess;
/** 控制类 */
@property (strong,nonatomic)AVPlayerItem  * playerItem;
/** 播放类 */
@property (strong,nonatomic)AVPlayer      * player;
/** 准备播放 */
@property (nonatomic, copy)void (^PlaySuccessBlock)();
/** 提示播放失败的原因 */
@property (nonatomic, copy)void (^playFailBlock)(NSString * );
/** 缓存的时间 */
@property (nonatomic, copy)void (^cacheTimeBlock)(CGFloat cachetime);
/** 当前播放的时间 */
@property (nonatomic, copy)void (^currentTimeBlock)(CGFloat currentTime);
/** 回调总时间 */
@property (nonatomic, copy)void (^TotalTimeBlock)(CGFloat totalTime);
/** 播放完成 */
@property (nonatomic, copy)void (^playEndBlock)();
/** 屏幕方向 */
@property (nonatomic, copy)void (^OrientationChange)(UIDeviceOrientation orient);

-(instancetype)initWithFrame:(CGRect)frame andURLstr:(NSString *)urlstr;

/**
 滑块拖动到多少秒

 @param second second即为slider.value;
 */
-(void)playerSeekToTimeWithSecond:(float)second;

@end
