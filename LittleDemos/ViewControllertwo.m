//
//  ViewControllertwo.m
//  demo
//
//  Created by 朱信磊 on 16/5/26.
//  Copyright © 2016年 朱信磊. All rights reserved.
//

#import "ViewControllertwo.h"
#import "ABCViewController.h"
@interface ViewControllertwo ()

@end

@implementation ViewControllertwo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(80, 80, 80, 80)];
    [bt setBackgroundColor:[UIColor yellowColor]];
    [bt setTitle:@"返回" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(pushaction) forControlEvents:UIControlEventTouchUpInside];;
    [self.view addSubview:bt];
    
    UIButton *brn = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 80, 80)];
    [self.view addSubview:brn];
    brn.backgroundColor = [UIColor blackColor];
    [brn addTarget:self action:@selector(tonext) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)tonext{
    ABCViewController *vc = [[ABCViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)pushaction{
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
