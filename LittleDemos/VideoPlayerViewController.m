//
//  VideoPlayerViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/4/1.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "GFVideoPlayer.h"
@interface VideoPlayerViewController ()

@property(nonatomic,strong)GFVideoPlayer *player;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 为我自己创建的类，继承于UIView，用于承载AVPlayer，此处用了固定的frame，自己在使用时可以根据需要设定具体的frame
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]pathForResource:@"海贼王精彩剪辑" ofType:@"mp4"]];
    
    self.player = [[GFVideoPlayer alloc] initWithFrame:CGRectMake(0, (ScreenHeight - ScreenWidth * 0.75) / 2, ScreenWidth, ScreenWidth * 0.75) videoURL:url];
    
    [self.view addSubview:self.player];
    
    [self.player setPlayBtn_block:^(GFVideoPlayer *sender){
        NSLog(@"typedef void (^testBlock)(GCQVideoPlayer *sender);");
    }];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playBtn];
    playBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) / 2.0f, CGRectGetMaxY(self.player.frame) + 8, 100, 60);
    [playBtn setTitle:@"开始" forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *pauseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:pauseBtn];
    pauseBtn.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 100) / 2.0f, CGRectGetMaxY(playBtn.frame) + 8, 100, 60);
    [pauseBtn setTitle:@"暂停" forState:UIControlStateNormal];
    [pauseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [pauseBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pauseBtn.tag = 10;
}
- (void)btnClick:(UIButton *)sender{
    if (sender.tag == 10) {
        [self.player pause];
        
    }else{
        [self.player play];
    }
    
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
