//
//  ViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/3/31.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ViewController.h"
#import "ImageCutViewController.h"
#import "NPCViewController.h"
#import "VideoPlayerViewController.h"
#import "ViewControllerOne.h"
#import "ProgressViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)NSArray *functionArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _functionArray = @[@"image分割",@"图片放大并播放音频",@"视频播放器",@"每个页面固定屏幕，屏幕固定",@"Mov转Mp4格式,参考ForMatViewController，调用方法即可",@"自定义ProgressView"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth,  ScreenHeight - 20)];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.functionArray[indexPath.row];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.functionArray.count;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self.navigationController pushViewController:[ImageCutViewController new] animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:[NPCViewController new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[VideoPlayerViewController new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[ViewControllerOne new] animated:YES];
            break;
        case 4:
            
            break;
        case 5:
            [self.navigationController pushViewController:[ProgressViewController new] animated:YES];
            
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
