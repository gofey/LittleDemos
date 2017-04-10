//
//  ProgressViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/4/10.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ProgressViewController.h"
#import "GFProgressView.h"
@interface ProgressViewController ()

@property(nonatomic,strong)GFProgressView *energyProgressView;
@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
     
     ***这个控件每个图都需要UI很好的配合，不然很容易变形，控件的大小最好与图片尺寸匹配，尤其是进度图片，我的这个图片就是不好，导致效果不佳
     ***望注意
     
     */
    
    
    
    
    //一定得用 initWithFrame 方法初始化，不然内部控件没有大小
    self.view.backgroundColor = [UIColor whiteColor];
    GFProgressView *energyProgressView = [[GFProgressView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 208) / 2, 100, 208, 17.5)];
    [self.view addSubview:energyProgressView];
    self.energyProgressView = energyProgressView;
    //设置背景图
    energyProgressView.trackImage = [UIImage imageNamed:@"energyProgressBgImage"];
    //设置进度颜色 有进度图时候不显示进度颜色
    energyProgressView.progressColor = [UIColor greenColor];
    //设置进度 图片。
    energyProgressView.progressImage = [UIImage imageNamed:@"progressImage"];
    //右边小散光的图片，这个图片位置可以进入内部去调整，关键看你的图片大小
    //默认不显示，只有在设置图片才显示
    energyProgressView.progressRightImage = [UIImage imageNamed:@"energyProgressTopImage"];
    
    energyProgressView.progress = 0.5;
    
    //放置数据的背景图 如果不需要可以在内部设置hidden为yes  默认就是yes
    
    energyProgressView.progressDataBgImage = [UIImage imageNamed:@"energyDataBg"];
    
    //数据总值就是在progress是1的状态下的值
    energyProgressView.dataTatal = 100;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(100, CGRectGetMaxY(energyProgressView.frame), 80, 35);
    [btn setTitle:@"Add" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(add:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)add:(UIButton *)sender{
    [self.energyProgressView setProgress:0.8 animated:YES];
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
