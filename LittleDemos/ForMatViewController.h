//
//  ForMatViewController.h
//  LittleDemos
//
//  Created by 厉国辉 on 2017/4/10.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForMatViewController : UIViewController

+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock;
@end
