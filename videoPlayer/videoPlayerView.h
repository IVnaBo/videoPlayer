//
//  videoPlayerView.h
//  videoPlayer
//
//  Created by BO on 17/3/15.
//  Copyright © 2017年 xsqBO. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
@interface videoPlayerView : UIView

/**
 滑块是否移动...
 */
@property (copy,nonatomic)void(^SliderisDrag)(BOOL);

/**
 初始化视频播放器控件

 @param frame frame
 @param  videoURLstr sss
 @return 视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame andvideoURLstr:(NSString*)videoURLstr;

@end
