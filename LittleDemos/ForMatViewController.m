//
//  ForMatViewController.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/4/10.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ForMatViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ForMatViewController ()

@end

@implementation ForMatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock
{
    /**
     *  mov格式转mp4格式
     */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
        
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *uniqueName = [NSString stringWithFormat:@"%@.mp4",[formatter stringFromDate:date]];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString * resultPath = [path stringByAppendingPathComponent:uniqueName];//PATH_OF_DOCUMENT为documents路径
        
        NSLog(@"output File Path : %@",resultPath);
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;//可以配置多种输出文件格式
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 
             });
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusUnknown");
                     NSLog(@"视频格式转换出错Unknown"); //自定义错误提示信息
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusWaiting");
                     NSLog(@"视频格式转换出错Waiting");
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusExporting");
                     NSLog(@"视频格式转换出错Exporting");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     
                     //                     NSLog(@"AVAssetExportSessionStatusCompleted");
                     
                     comepleteBlock(resultPath);
                     
                     NSLog(@"mp4 file size:%lf MB",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                 }
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusFailed");
                     NSLog(@"视频格式转换出错Unknown");
                     
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     
                     //                     NSLog(@"AVAssetExportSessionStatusFailed");
                     NSLog(@"视频格式转换出错Cancelled");
                     
                     break;
                     
             }
             
         }];
        
    }
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
