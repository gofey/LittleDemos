//
//  UIImage+CutImage.h
//  gif
//
//  Created by lijie on 16/9/29.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CutImage)

// 类方法  传入参数 image（被切图片） rect 切得范围
+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect) rect;
//切 调用对象本身
- (UIImage *)cutImagewithRect:(CGRect )rect;
//- (UIImage *)cutImageInAnimation;
+ (NSArray<UIImage *> *) getImageArrayWithImageName:(NSString *)wholeImageName withCount:(NSInteger) count;
@end
