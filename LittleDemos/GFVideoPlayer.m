//
//  GCQVideoPlayer.m
//  视频封装
//
//  Created by gofey on 2016/10/20.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import "GFVideoPlayer.h"
#import "BottomBaseView.h"
#import "UIColor+Hex.h"
@interface GFVideoPlayer(){
    CGFloat barHeight ;
    NSTimeInterval secondsTimer;
    BOOL isFastMove;
    BOOL isPlay;
}
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;//视频播放器的layer层视图
@property (nonatomic, strong) AVPlayerItem *playItem;//


@property (nonatomic, assign) NSTimeInterval totalTime;//记录视频总时长

@property (nonatomic, assign) BOOL hidenBar;//视频UI控件是否显示的标识

@property (nonatomic, assign) BOOL isFullScreen;//全屏状态标识
@property (nonatomic, assign) CGRect originalFrame;//记录播放器原始frame

@property (nonatomic, strong) UIImageView *backIamge;//背景图

@property (nonatomic, strong) UILabel *timeLabel;//显示视频已完成的播放时长/总播放时长
@property (nonatomic, strong) UIButton *playButton;//播放暂停按钮

@property (nonatomic, strong) UISlider *playSlider;//播放进度条
@property (nonatomic, strong) UIButton *fillScreenButton;
@property (nonatomic, strong) UIView *bottomView;//承载上述控件的UIView
@property (nonatomic, strong) UIView *superView;//记录下全屏前的父视图，便于退出全屏后视频处在正确的位置
@property (nonatomic,strong) NSTimer *timer;

//实现快进快退
@property (nonatomic, strong) UIView *progressTipView;
@property (nonatomic, assign) NSTimeInterval currentTime;//记录视频总时长
@property (nonatomic, strong) UILabel *progressTipLabel;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, strong) UIImageView *progressTipImageView;
@property (nonatomic, strong) UIProgressView *progressTipProgressView;

@end
@implementation GFVideoPlayer

#pragma mark - 快进或快退时 中间显示内容
- (UILabel *)progressTipLabel{
    if (!_progressTipLabel) {
        _progressTipLabel = [[UILabel alloc] init];
        _progressTipLabel.font = [UIFont systemFontOfSize:20];
        _progressTipLabel.textColor = [UIColor whiteColor];
    }
    return _progressTipLabel;
}
- (UIView *)progressTipView{
    if (!_progressTipView) {
        UIView *progressTipView = [[UIView alloc] init];
        progressTipView.frame = CGRectMake((self.frame.size.width - 195 ) / 2.0f, (self.frame.size.height - 105 ) / 2.0f, 195, 105);
        _progressTipView = progressTipView;
        progressTipView.backgroundColor = [UIColor colorWithHexString:@"#00183c" alpha:0.85];
        progressTipView.layer.cornerRadius = 10;
        progressTipView.clipsToBounds = YES;
        //前进后退图标
        UIImageView *progressTipImageView = [[UIImageView alloc] initWithFrame:CGRectMake((progressTipView.frame.size.width - 56) / 2.0f, 17, 56, 35)];
        [progressTipView addSubview:progressTipImageView];
        self.progressTipImageView = progressTipImageView;
        progressTipImageView.image = [UIImage imageNamed:@"kuaijin"];
        
        //提示文字进度
        self.progressTipLabel.text = @"00:00/00:00";
        [progressTipView addSubview:self.progressTipLabel];
        CGSize size = CGSizeMake(1000, 1000);
        NSDictionary *attribute = @{NSFontAttributeName:self.progressTipLabel.font};
        size = [self.progressTipLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        self.progressTipLabel.frame = CGRectMake((progressTipView.bounds.size.width - size.width) / 2.0f, CGRectGetMaxY(progressTipImageView.frame) + 15, size.width, size.height);
        self.progressTipView.hidden = YES;
        
        //小版进度条
        UIProgressView *progressTipProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.progressTipLabel.frame) + 8, progressTipView.frame.size.width - 40, 15)];
        [progressTipView addSubview:progressTipProgressView];
        self.progressTipProgressView = progressTipProgressView;
        progressTipProgressView.backgroundColor = [UIColor clearColor];
//        progressTipProgressView.progressTintColor= [UIColor colorWithHexString:@"#aece4f"];//设置已过进度部分的颜色
        progressTipProgressView.progressTintColor= [UIColor yellowColor];
        progressTipProgressView.trackTintColor= [UIColor colorWithHexString:@"#bfbfbf"];//设置未过进度部分的颜色
        
    }
    return _progressTipView;
}
#pragma mark - 自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame videoURL:(NSURL *)url
{
    
    if (self = [super initWithFrame:frame]) {
        self.hidenBar = NO;
        self.isFullScreen = NO;
        isPlay = NO;
        self.video_url = url;
        self.backgroundColor = [UIColor blackColor];
        self.currentTime = 0;
        self.currentPoint = CGPointZero;
        self.layer.masksToBounds = YES;
        secondsTimer = 3.0f;
        self.originalFrame = frame;
        //播放完毕通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(videoPlayDidEnd)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                     name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
        [self initPlayer:frame];
    }
    return self;
}

- (void)initPlayer:(CGRect )frame{
    //初始化AVPlayer控制器
    self.playItem = [[AVPlayerItem alloc] initWithURL:self.video_url];

    [self addObserverWithPlayerItem:self.playItem];
    self.player = [AVPlayer playerWithPlayerItem:self.playItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor blackColor].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    
    [self addProgressObserver];
    [self.layer addSublayer:self.playerLayer];
    self.playerLayer.frame = self.bounds;
    
    // 初始化内部控件
    [self initSubViews:frame];
    
}
- (void)initSubViews:(CGRect)frame{
    CGFloat bottomViewW = frame.size.width;
    CGFloat bottomViewH = 40;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = frame.size.height - bottomViewH;
    barHeight = bottomViewH;
    self.bottomView = [[BottomBaseView alloc] initWithFrame:CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH)];
    [self addSubview:self.bottomView];
    
    UIGestureRecognizer *gestureTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
    
    [self.bottomView addGestureRecognizer:gestureTap];
    UIGestureRecognizer *gestureLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
    [self.bottomView addGestureRecognizer:gestureLongPress];
    
    UIGestureRecognizer *gesturePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(bottomGesture:)];
    [self.bottomView addGestureRecognizer:gesturePan];
    
    
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    //    self.bottomView.timer = self.timer;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bottomView addSubview:self.playButton];
    self.playButton.frame = CGRectMake(0, 0, bottomViewH, bottomViewH);
    [self.playButton setImage:[UIImage imageNamed:@"playBtnImg"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"playBtnImgselected"] forState:UIControlStateSelected];
    [self.playButton addTarget:self action:@selector(playBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat fillScreenButtonX = bottomViewW - bottomViewH;
    CGFloat fillScreenButtonY = 0;
    CGFloat fillScreenButtonW = bottomViewH;
    CGFloat fillScreenButtonH = bottomViewH;
    
    
    self.fillScreenButton = [[UIButton alloc] initWithFrame:CGRectMake(fillScreenButtonX, fillScreenButtonY, fillScreenButtonW, fillScreenButtonH)];
    [self.bottomView addSubview:self.fillScreenButton];
    [self.fillScreenButton setImage:[UIImage imageNamed:@"fillScreenBtnImg"] forState:UIControlStateNormal];
    [self.fillScreenButton setImage:[UIImage imageNamed:@"fillScreenBtnImgSelected"] forState:UIControlStateSelected];
    [self.fillScreenButton addTarget:self action:@selector(fillScreenButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.font = [UIFont systemFontOfSize:17];
    
    self.timeLabel.text = @"00:00/00:00";
    [self.bottomView addSubview:self.timeLabel];
    
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    
    //计算实际frame大小，并将label的frame变成实际大小
    CGSize size = CGSizeMake(1000,10000);
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat timeLabelY = 0;
    CGFloat timeLabelW = labelsize.width + 10;
    CGFloat timeLabelH = bottomViewH;
    CGFloat timeLabelX = bottomViewW - fillScreenButtonW - timeLabelW - 10;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    
    CGFloat silderX = CGRectGetMaxX(self.playButton.frame) + 15;
    CGFloat silderW = timeLabelX - silderX - 15;
    CGFloat silderH = 10;
    CGFloat silderY = (self.bottomView.bounds.size.height - silderH) / 2.0;
    self.playSlider = [[UISlider alloc] initWithFrame:CGRectMake(silderX, silderY, silderW, silderH)];
    [self.bottomView addSubview:self.playSlider];
    [self.playSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuan"] forState:UIControlStateNormal];
    [self.playSlider setMinimumTrackTintColor:[UIColor blueColor] ];
    [self.playSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
    [self.playSlider addTarget:self action:@selector(progressValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.playSlider addTarget:self action:@selector(playSliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.playSlider addTarget:self action:@selector(playSliderTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
    
    
    [self addSubview:self.progressTipView];
    
}
#pragma mark - 隐藏状态栏和显示状态栏方法
- (void)hideBottomBar{
    NSLog(@"hideBottomBar");
    self.hidenBar = YES;
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.origin.y = self.bounds.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomView.frame = bottomRect;
    }];
}
- (void)appearBottomBar{
    NSLog(@"appearBottomBar");
    self.hidenBar = NO;
    CGRect bottomRect = self.bottomView.frame;
    bottomRect.origin.y = self.bounds.size.height - self.bottomView.frame.size.height;
    [UIView animateWithDuration:0.4 animations:^{
        self.bottomView.frame = bottomRect;
    }];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:secondsTimer target:self selector:@selector(hideBottomBar) userInfo:nil repeats:NO];

}
- (void)bottomGesture:(UIGestureRecognizer *)gesture{
    NSLog(@"rr");
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:secondsTimer target:self selector:@selector(hideBottomBar) userInfo:nil repeats:NO];
}
- (void)updateSubViewsFrame:(CGRect )frame{
    
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    [self.layer addSublayer:self.playerLayer];
    
    [self bringSubviewToFront:self.bottomView];
    CGFloat bottomViewW = frame.size.width;
    CGFloat bottomViewH = barHeight;
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = frame.size.height - bottomViewH;
    self.bottomView.frame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    
    self.center = CGPointMake(self.frame.origin.x + self.frame.size.width/2.0, self.frame.origin.y + self.frame.size.height/2.0);
    
    self.playButton.frame = CGRectMake(0, 0, bottomViewH, bottomViewH);
    CGFloat fillScreenButtonX = bottomViewW - bottomViewH;
    CGFloat fillScreenButtonY = 0;
    CGFloat fillScreenButtonW = bottomViewH;
    CGFloat fillScreenButtonH = bottomViewH;
    
    self.fillScreenButton.frame = CGRectMake(fillScreenButtonX, fillScreenButtonY, fillScreenButtonW, fillScreenButtonH);
    
    CGSize size = CGSizeMake(1000,10000);
    NSDictionary *attribute = @{NSFontAttributeName:self.timeLabel.font};
    CGSize labelsize = [self.timeLabel.text boundingRectWithSize:size options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    CGFloat timeLabelY = 0;
    CGFloat timeLabelW = labelsize.width + 10;
    CGFloat timeLabelH = bottomViewH;
    CGFloat timeLabelX = bottomViewW - fillScreenButtonW - timeLabelW - 10;
    self.timeLabel.frame = CGRectMake(timeLabelX, timeLabelY, timeLabelW, timeLabelH);
    
    CGFloat silderX = CGRectGetMaxX(self.playButton.frame) + 15;
    CGFloat silderW = timeLabelX - silderX - 15;
    CGFloat silderH = 10;
    CGFloat silderY = (self.bottomView.bounds.size.height - silderH) / 2.0;
    self.playSlider.frame = CGRectMake(silderX, silderY, silderW, silderH);
}
#pragma mark - touch方法群
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    isFastMove = NO;
    
    NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
//    NSLog(@"%@",NSStringFromCGRect([touch view].frame));
    
//    NSLog(@"currentTime %f",self.currentTime);
    self.progressTipLabel.text = [self formatPlayTime:self.currentTime];
    self.currentPoint = point;
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSSet *allTouches = [event allTouches];  //返回与当前接收者有关的所有的触摸对象
    UITouch *touch = [allTouches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
    //    NSLog(@"%@",NSStringFromCGPoint(point));
    
    if (point.x - self.currentPoint.x < 10 && point.x - self.currentPoint.x > -10) {
        return;
    }
    
    [self.progressTipProgressView setProgress:self.playSlider.value];
    isFastMove = YES;
    self.progressTipView.hidden = NO;
    if ((point.x >= 0 && point.x <= [touch view].bounds.size.width)&&(point.y >= 0 && point.y <= [touch view].bounds.size.height)) {
        if (point.x - self.currentPoint.x <= 0) {
            self.progressTipImageView.image = [UIImage imageNamed:@"kuaitui"];
        }else{
            self.progressTipImageView.image = [UIImage imageNamed:@"kuaijin"];
        }
        
        float cha = (point.x - self.currentPoint.x) / 10;
        self.currentTime = self.currentTime + cha;
        self.currentPoint = point;
        
        if (self.currentTime <= 0) {
            self.progressTipLabel.text = [self formatPlayTime:0.0f];
            self.currentTime = 0;
        }
        else if(self.currentTime >= self.totalTime){
            self.progressTipLabel.text = [self formatPlayTime:self.totalTime];
            self.currentTime = self.totalTime;
        }
        else{
            self.progressTipLabel.text = [self formatPlayTime:self.currentTime];
        }
        [self.playSlider setValue:(self.currentTime / self.totalTime) animated:YES];
        [self.progressTipProgressView setProgress:(self.currentTime / self.totalTime) animated:YES];
    }else{
        NSLog(@"outside");
    }
}
- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.player.rate == 1) {
        [self pause];
    }
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (isFastMove) {
        if (self.player.rate == 0) {
            
            [self.player seekToTime:CMTimeMake(self.currentTime*10, 10.0)];
            
        } else if(self.player.rate == 1) {
            [self pause];
            [self.player seekToTime:CMTimeMake(self.currentTime*10, 10.0)];
        }else{
            NSLog(@"rate:%f",self.player.rate);
        }
        self.progressTipView.hidden = YES;
        [self play];
    }else{
        
        [self.timer invalidate];
        if (self.hidenBar) {
            [self appearBottomBar];
        }else{
            [self hideBottomBar];
        }
    }
    
    
}
#pragma mark - playSlider添加事件
- (void)playSliderTouchUp:(UISlider *)sender{
    [self hideBottomBar];
    [self play];
}
- (void)progressValueChange:(UISlider *)sender{

    [self.timer invalidate];
    if (self.player.rate == 0) {
        [self.player seekToTime:CMTimeMake(sender.value*self.totalTime*10, 10.0)];

    } else if(self.player.rate == 1) {
        [self pause];
        [self.player seekToTime:CMTimeMake(sender.value*self.totalTime*10, 10.0)];
    }else{
        NSLog(@"rate:%f",self.player.rate);
    }
    
}

#pragma mark - 按钮点击事件
- (void)playBtnTouchUpInside:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.player play];
        [self hideBottomBar];
    }else{
        [self.player pause];
        [self.timer invalidate];
    }
    if (self.playBtn_block) {
        self.playBtn_block(self);
    }
}

- (void)fillScreenButtonTouchUpInside:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //进入全屏
        self.superView = self.superview;
        [self.window addSubview:self];
        [self.window bringSubviewToFront:self];
        
        [UIView animateWithDuration:0.2f animations:^{
            self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            
            //            self.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2.0, ([UIScreen mainScreen].bounds.size.height)/2.0);
            [self updateSubViewsFrame:self.frame];
        }];
        
    }
    else{
        //返回原状态
        [UIView animateWithDuration:0.2f animations:^{
            //旋转360度
            self.frame = self.originalFrame;
            
            [self updateSubViewsFrame:self.frame];
            [self.superView addSubview:self];
        }];
        
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:secondsTimer target:self selector:@selector(hideBottomBar) userInfo:nil repeats:NO];
}
//将时间改为00:00格式
- (NSString *)formatPlayTime:(NSTimeInterval)duration
{

    int minute = 0, secend = duration;
    minute = secend / 60;
    secend = secend % 60;
    int totalMin = 0,totalSecond = self.totalTime ;
    totalMin = totalSecond / 60;
    totalSecond = totalSecond % 60;
    return [NSString stringWithFormat:@"%02d:%02d/%02d:%02d", minute, secend,totalMin,totalSecond];

}

#pragma mark - 监听事件
//添加avplayer block回调
- (void)addProgressObserver{
    __weak __typeof(self) weakSelf = self;
    //这里设置每秒执行一次
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(10.0, 10.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        NSTimeInterval current = CMTimeGetSeconds(time);//获取当前的播放时间
   
        weakSelf.currentTime = current;
        //如果没有手动拖拽在进行自动更新
        
        [weakSelf.playSlider setValue:(current / self.totalTime) animated:YES];
        //设置UILabel视图显示当前播放时长
        weakSelf.timeLabel.text = [weakSelf formatPlayTime:current];

        
    }];
}
//注册观察者监听状态和缓冲
- (void)addObserverWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
}
//移除观察者，移除监听
- (void)removeObserveWithPlayerItem:(AVPlayerItem *)playerItem
{
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [playerItem removeObserver:self forKeyPath:@"status"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    AVPlayerItem *playItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //当前播放器状态
        if ([playItem status] == AVPlayerItemStatusReadyToPlay) {
            self.totalTime = CMTimeGetSeconds(playItem.duration);
            //[self playBtnTouchUpInside:self.playButton];
            self.timeLabel.text = [self formatPlayTime:0.0f];
            self.progressTipLabel.text = self.timeLabel.text;
        }else{
            NSLog(@"这个视频有毒...");
        }
    }
    else if([keyPath isEqualToString:@"loadedTimeRanges"]){
        //计算缓冲
    }
    else{
        NSLog(@"...");
    }
}
- (void)videoPlayDidEnd{
    NSLog(@"结束啦");
    [self.playItem setReversePlaybackEndTime:kCMTimeZero];
    [self.playItem seekToTime:kCMTimeZero];
    [self.playSlider setValue:0.0 animated:YES];
    self.playButton.selected = NO;
}
- (void)applicationWillResignActive:(NSNotification *)notification

{
//    printf("按理说是触发home按下\n");
    if(self.player.rate == 1) {

        isPlay = YES;
        [self pause];
    }else{
        isPlay = NO;
    }
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
//    printf("按理说是重新进来后响应\n");
    if (isPlay) {
        [self play];
    }
}
#pragma mark - 对外延伸接口
- (void)dealloc{
    [self removeObserveWithPlayerItem:self.playItem];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"go to die");
    
}
- (void)play{
    self.playButton.selected = YES;
    [self.player play];
    [self hideBottomBar];
}
- (void)pause{
    self.playButton.selected = NO;
    [self.player pause];
    [self.timer invalidate];
}
- (void)stop{
    self.playButton.selected = NO;
//    [self.player pause];

    [self.playItem setReversePlaybackEndTime:kCMTimeZero];
    [self.playItem seekToTime:kCMTimeZero];
    [self.playSlider setValue:0.0 animated:YES];
    [self.timer invalidate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
