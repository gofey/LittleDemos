//
//  NPCView.m
//  gif
//
//  Created by lijie on 16/9/27.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import "NPCView.h"
#import <AVFoundation/AVFoundation.h>
@interface NPCView()<AVAudioPlayerDelegate>{
    BOOL _isplay;
}
@property(strong , nonatomic)UIImageView *imageView;
@property(strong , nonatomic)AVAudioPlayer *avAudioPlayer;

@end
@implementation NPCView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isplay = NO;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self addGestureRecognizer:tap];
        
        //获取通知中心单例对象
        NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
//        [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
        [notification addObserver:self selector:@selector(noticeIsAnimation:) name:@"NPCNotification" object:nil];
    }
    return self;
}
- (void)noticeIsAnimation:(id)sender{
//    [self.avAudioPlayer stop];
    
//    self.avAudioPlayer.currentTime = 0.0;
    [self stopAnimation];
}
//重写get方法
- (UIImageView *)imageView{
    
    if (!_imageView) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        _imageView = imageView;
        
        imageView.animationDuration = 0.8;
        imageView.animationRepeatCount = 0;
//        imageView.userInteractionEnabled = YES;
        
    }
    return _imageView;
}
//设置图片数组
- (void)setImagesArray:(NSArray<UIImage *> *)imagesArray{
    self.imageView.image = imagesArray[0];
    self.imageView.animationImages = imagesArray;
}
- (AVAudioPlayer *)avAudioPlayer{
    if (!_avAudioPlayer) {
        //播放音频
        
        //把音频文件转换成url格式
        NSURL *url = [NSURL fileURLWithPath:self.audioPath];
        //初始化音频类 并且添加播放文件
        AVAudioPlayer  *avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        _avAudioPlayer = avAudioPlayer;
        avAudioPlayer.delegate = self;
        //预播放
        [avAudioPlayer prepareToPlay];
        avAudioPlayer.volume = 1;
//        NSLog(@"%f",avAudioPlayer.duration);
    }
    return _avAudioPlayer;
}
//设置子类frame
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

//轻触图片手势方法
- (void)startPlayingAnimation{
    [self tapGesture:nil];
}
//手势
- (void)tapGesture:(UITapGestureRecognizer *)sender{
    NSNotification * notice = [NSNotification notificationWithName:@"NPCNotification" object:nil userInfo:nil];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    [self startAnimation];
    
    
}
//开始动画
- (void)startAnimation{
    if (!_isplay) {
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.8 animations:^{
            self.imageView.layer.affineTransform = CGAffineTransformMakeScale(2.0f, 2.0f);
        }];
        [self.imageView startAnimating];
        [self.avAudioPlayer play];
        self.userInteractionEnabled = YES;
        _isplay = !_isplay;
    }
}
//播放结束时触发的代理方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"播放结束了，亲~~~");
    [self stopAnimation];
    
    
}
//停止动画
- (void)stopAnimation{
    
    if (_isplay) {
        [self.imageView stopAnimating];
        [self.avAudioPlayer stop];
        self.avAudioPlayer.currentTime = 0.0;
        self.userInteractionEnabled = NO;
        [UIView animateWithDuration:0.8 animations:^{
//            self.imageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
            self.imageView.layer.affineTransform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            _isplay = !_isplay;
            self.userInteractionEnabled = YES;
        }];
    }
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
@end
