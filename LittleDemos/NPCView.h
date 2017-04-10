//
//  NPCView.h
//  gif
//
//  Created by lijie on 16/9/27.
//  Copyright © 2016年 lijie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NPCView : UIView
//传的是动画组的图片数组
@property (nonatomic,strong)NSArray<UIImage *> *imagesArray;
//音频名字
@property(nonatomic,copy)NSString *audioPath;
- (void)startPlayingAnimation;
- (void)stopAnimation;
//动画时间
//@property(nonatomic,assign)float animationDuration;
@end
