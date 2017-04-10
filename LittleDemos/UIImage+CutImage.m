//
//  UIImage+CutImage.m
//  gif
//
//  Created by lijie on 16/9/29.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import "UIImage+CutImage.h"

@implementation UIImage (CutImage)

// 类方法  传入参数 image（被切图片） rect 切得范围
+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect )rect
{
    CGImageRef cgRef = image.CGImage;
    CGImageRef newRef = CGImageCreateWithImageInRect(cgRef, rect);
    UIImage *result = [UIImage imageWithCGImage:newRef];
    CGImageRelease(newRef);
    return result;
}
//切 调用对象本身
- (UIImage *)cutImagewithRect:(CGRect )rect
{
    CGImageRef cgRef = self.CGImage;
    CGImageRef newRef = CGImageCreateWithImageInRect(cgRef, rect);
    UIImage *result = [UIImage imageWithCGImage:newRef];
    CGImageRelease(newRef);
    return result;
    
}
//切完之后直接返回切好图片的数组
+ (NSArray<UIImage *> *) getImageArrayWithImageName:(NSString *)wholeImageName withCount:(NSInteger) count{
    NSMutableArray *images = [NSMutableArray array];
    UIImage *wholeImage = [UIImage imageNamed:wholeImageName];
    CGFloat width = wholeImage.size.width / count;
    CGFloat height = wholeImage.size.height;
    for (int i = 0; i < count; i++) {
        UIImage *image = [UIImage cutImage:wholeImage withRect:CGRectMake(i * width, 0, width, height)];
        [images addObject:image];
    }
    return images;
}
@end
