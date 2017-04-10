//
//  GFProgressView.m
//  StudentSign
//
//  Created by 厉国辉 on 2017/3/9.
//  Copyright © 2017年 lijie. All rights reserved.
//

#import "GFProgressView.h"
#import "UIView+Extension.h"
@interface GFProgressView()

// 进度条背景图片View
@property (strong, nonatomic) UIImageView *trackView;

// 进度条进度图片遮罩View
@property (strong, nonatomic) UIImageView *progressMaskView;

// 进图条填充图片View
@property (strong, nonatomic) UIImageView *progressView;

// 进图条填充顶部图片View
@property (strong, nonatomic) UIImageView *progressRightView;

//展示数据view
@property (strong, nonatomic) UIImageView *progressDataImageView;

//展示数据view
@property (strong, nonatomic) UILabel *dataLabel;

@end

@implementation GFProgressView{
    CGFloat _wholeWidth;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        //初始化

        UIImageView *trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:trackView];
        self.trackView = trackView;
        trackView.clipsToBounds = YES;
        self.layer.cornerRadius = frame.size.height / 2;
        UIImageView *progressView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 3, frame.size.width - 2, frame.size.height - 6)];
        [self addSubview:progressView];
        _wholeWidth = progressView.width;
        self.progressView = progressView;
        progressView.clipsToBounds = YES;
        progressView.layer.cornerRadius = progressView.height / 2;
        
        UIImageView *progressRightView = [[UIImageView alloc] initWithFrame:CGRectMake(progressView.x - 33, (frame.size.height - 32) / 2,33, 32)];
        [self addSubview:progressRightView];
        self.progressRightView = progressRightView;
        progressRightView.hidden = YES;
        
        UIImageView *progressDataImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
        [self addSubview:progressDataImageView];
        self.progressDataImageView = progressDataImageView;
        progressDataImageView.hidden = YES;
        
        UILabel *dataLabel = [[UILabel alloc] initWithFrame:progressDataImageView.bounds];
        [progressDataImageView addSubview:dataLabel];
        self.dataLabel = dataLabel;
        dataLabel.textColor = [UIColor whiteColor];
        dataLabel.font = [UIFont systemFontOfSize:17];
        dataLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return self;
}

- (void)setProgressImage:(UIImage *)progressImage{
    _progressImage = progressImage;
//    CGSize size = progressImage.size;
//    NSLog(@"%@",NSStringFromCGSize(size));
    self.progressView.image = progressImage;
    self.progressView.backgroundColor = [UIColor clearColor];
    
    self.progressView.layer.cornerRadius = 0;
//    self.progressView.contentMode = UIViewContentModeLeft;
//    _wholeWidth = size.width - 4;
//
//    self.progressView.frame = CGRectMake(2, (self.height - size.height) / 2, (size.width - 4) * _progress , size.height);
//    _wholeWidth = self.progressView.width;

}

- (void)setTrackImage:(UIImage *)trackImage{
    _trackImage = trackImage;
    self.trackView.image = trackImage;
    self.trackView.backgroundColor = [UIColor clearColor];
}
- (void)setProgressDataColor:(UIColor *)progressDataColor{
    self.dataLabel.textColor = progressDataColor;
    
}

- (void)setProgressDataBgColor:(UIColor *)progressDataBgColor{
    self.progressDataImageView.backgroundColor = progressDataBgColor;
}
- (void)setDataTatal:(float)dataTatal{
    _dataTatal = dataTatal;
    self.progressDataImageView.hidden = NO;
    if (!self.progressDataImageView.image) {
        self.progressDataImageView.backgroundColor = [UIColor blackColor];
        self.dataLabel.frame = self.progressDataImageView.bounds;
    }
    self.dataLabel.text = [NSString stringWithFormat:@"%.0f",dataTatal * self.progress];
}

- (void)setProgressRightImage:(UIImage *)progressRightImage{
    _progressRightImage = progressRightImage;
    self.progressRightView.hidden = NO;
    self.progressRightView.image = progressRightImage;
//        CGSize size = CGSizeMake(progressRightImage.size.width / 2, progressRightImage.size.height / 2);
    CGSize size = progressRightImage.size;
//    NSLog(@"%@",NSStringFromCGSize(size));
    
    self.progressRightView.frame = CGRectMake(self.progressView.width - size.width / 2, (self.height - size.height) / 2 , size.width, size.height);
    self.dataLabel.frame = CGRectMake(0, 0, size.width, size.height);
}
- (void)setProgressDataBgImage:(UIImage *)progressDataBgImage{
    self.progressDataImageView.hidden = NO;
//    CGSize size = progressDataBgImage.size;
    self.progressDataImageView.backgroundColor = [UIColor clearColor];
    self.progressDataImageView.backgroundColor = [UIColor clearColor];
    self.progressDataImageView.image = progressDataBgImage;
    CGSize size = CGSizeMake(progressDataBgImage.size.width / 2, progressDataBgImage.size.height / 2);
//    NSLog(@"%@",NSStringFromCGSize(size));
    self.progressDataImageView.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame), - size.height - 5, size.width, size.height);
    self.dataLabel.frame = CGRectMake(0, 0, size.width, 24);
    
}

- (void)setTrackColor:(UIColor *)trackColor{
    if (!self.trackImage) {
        self.trackView.backgroundColor = trackColor;
    }
}
- (void)setProgressColor:(UIColor *)progressColor{
    if (!self.progressImage) {
        self.progressView.backgroundColor = progressColor;
    }
}
//设置进度条的值
- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (progress > 1) {
        progress = 1;
    }
    [self setProgress:progress animated:NO];
}
//修改显示内容
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    _progress = progress;
    self.dataLabel.text = [NSString stringWithFormat:@"%.0f",_dataTatal * progress];
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self chageFrame];
        } completion:^(BOOL finished) {
            
        }];
        
    }else{
        [self chageFrame];
        
    }
}


//改变Frame
- (void)chageFrame{
    //调整进度View的frame
    self.progressView.frame = CGRectMake(_progressView.x, _progressView.y, _wholeWidth * _progress, _progressView.height);
    //调整右边光view的frame
    self.progressRightView.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame) - 50, _progressRightView.y, _progressRightView.width, _progressRightView.height);
    //调整上部显示数据view的frame
    self.progressDataImageView.frame = CGRectMake(CGRectGetMaxX(self.progressView.frame), - _progressDataImageView.height - 5, _progressDataImageView.width, _progressDataImageView.height);
    
    self.dataLabel.text = [NSString stringWithFormat:@"%.0f",self.dataTatal * _progress];
//    NSLog(@"%@",NSStringFromCGRect(self.progressView.frame));
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
