//
//  GFProgressView.h
//  StudentSign
//
//  Created by 厉国辉 on 2017/3/9.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFProgressView : UIView

// 进度条背景图片
@property (strong, nonatomic) UIImage *trackImage;

// 进度条进度图片
@property (strong, nonatomic) UIImage *progressImage;

// 进图条右边点缀图片
@property (strong, nonatomic) UIImage *progressRightImage;

// 进图条顶端显示数据背景图片
@property (strong, nonatomic) UIImage *progressDataBgImage;

// 显示数据总数
@property (assign, nonatomic) float dataTatal;

// 进度条背景色
@property (strong, nonatomic) UIColor *trackColor;

// 进图条填充色
@property (strong, nonatomic) UIColor *progressColor;

// 显示数据背景色
@property (strong, nonatomic) UIColor *progressDataBgColor;

// 显示数据颜色
@property (strong, nonatomic) UIColor *progressDataColor;

// 进度
@property (nonatomic,assign) CGFloat progress;//0 - 1

//设置进度，选择是否需要动画
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
