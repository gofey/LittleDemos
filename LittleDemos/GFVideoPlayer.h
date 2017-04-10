//
//  GCQVideoPlayer.h
//  视频封装
//
//  Created by gofey on 2016/10/20.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class GFVideoPlayer;
typedef void (^playBtnBlock)(GFVideoPlayer *sender);
@interface GFVideoPlayer : UIView


@property (nonatomic, strong) NSURL *video_url;//接收视频连接
@property(nonatomic,copy)playBtnBlock playBtn_block;

- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url;//自定义初始化方法
//控制开启或者关闭播放器

- (void)play;
- (void)pause;
- (void)stop;
@end
