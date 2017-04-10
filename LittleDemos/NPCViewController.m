//
//  NPCViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/3/31.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "NPCViewController.h"
#import "NPCView.h"
@interface NPCViewController ()

@end

@implementation NPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /***
     
        一块创建三个人物的话，同时只有一个会播放语音及放大动画，以最后一个为准
        如果需要多个同时播放点击效果，可以改写通知方法或移除通知
     
     ***/
    self.view.backgroundColor = [UIColor whiteColor];
    NPCView *personView = [[NPCView alloc] initWithFrame:CGRectMake(0, 200, 2460 / 6 / 4, 768 / 4)];
   
    
    NSArray<UIImage *> *images = [UIImage getImageArrayWithImageName:@"whole" withCount:3];
    personView.imagesArray = images;
    
    personView.audioPath = [[NSBundle mainBundle] pathForResource:@"mp3" ofType:@"m4a"];
    
    NSLog(@"path:%@",personView.audioPath);
    
    
    NPCView *personViewTwo = [[NPCView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personView.frame) + 50, 200, 2460 / 6 / 4, 768 / 4)];
    
    personViewTwo.imagesArray = images;
    
    personViewTwo.audioPath = [[NSBundle mainBundle] pathForResource:@"mp3" ofType:@"m4a"];
    
    NPCView *personViewThree = [[NPCView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(personView.frame) + 50, 2460 / 6 / 4, 768 / 4)];

    personViewThree.imagesArray = images;
    
    personViewThree.audioPath = [[NSBundle mainBundle] pathForResource:@"mp3" ofType:@"m4a"];
    
    
    NPCView *personViewFour = [[NPCView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(personViewThree.frame) + 50, CGRectGetMaxY(personView.frame) + 50, 2460 / 6 / 4, 768 / 4)];
    
    personViewFour.imagesArray = images;
    
    personViewFour.audioPath = [[NSBundle mainBundle] pathForResource:@"mp3" ofType:@"m4a"];
    
    [self.view addSubview:personView];
    [self.view addSubview:personViewTwo];
    [self.view addSubview:personViewThree];
    [self.view addSubview:personViewFour];
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
