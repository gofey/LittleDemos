//
//  ImageCutViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/3/31.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ImageCutViewController.h"

@interface ImageCutViewController ()

@end

@implementation ImageCutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //为了项目调用方便，已为Image类创建category，详细可参考UIImage+CutImage.h
    
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    /*******************
     获取到的image的大小是原图大小，需要根据一定倍数进行缩减，不然会让图片变形
     ******************/
    UIImage *image = [UIImage imageNamed:@"WechatIMG6"];
    
    //原图太尼玛大了，只好缩小四倍来看
    UIImageView *originImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, 1063 / 4, 354 / 4)];
    [self.view addSubview:originImg];
    originImg.image = image;
    //1063 x 354 原图片大小
    
    NSInteger count = 3;
    CGFloat width = 531.5 / count;
    //
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        UIImage *imageCut = [self cutImage:image withRect:CGRectMake(width * i, 0, width, 177)];
        [imageArray addObject:imageCut];
    }
    UIImageView *leftIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(originImg.frame) + 30, 531.5 / 3.0, 177)];
    [self.view addSubview:leftIamgeView];
    leftIamgeView.image = imageArray[0];
    /*******************
            根据一定倍数进行缩减后
     ******************/
    UIImageView *middleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftIamgeView.frame) + 5, 531.5 / 3.0/2, 177/2)];
    [self.view addSubview:middleImageView];
    middleImageView.image = imageArray[1];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(middleImageView.frame) + 5, 531.5 / 3.0/4, 177/4)];
    [self.view addSubview:rightImageView];
    rightImageView.image = imageArray[2];
    
    
}
//关键方法
- (UIImage *)cutImage:(UIImage *)image withRect:(CGRect) rect
{
    CGImageRef cgRef = image.CGImage;
    CGImageRef newRef = CGImageCreateWithImageInRect(cgRef, rect);
    UIImage *result = [UIImage imageWithCGImage:newRef];
    CGImageRelease(newRef);
    return result;
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
