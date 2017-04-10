//
//  ViewControllerOne.m
//  LittleDemos
//
//  Created by 厉国辉 on 2017/4/1.
//  Copyright © 2017年 Xschool. All rights reserved.
//

#import "ViewControllerOne.h"
#import "ViewControllertwo.h"
@interface ViewControllerOne ()

@end

@implementation ViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *bt = [[UIButton alloc]initWithFrame:CGRectMake(80, 80, 80, 80)];
    [bt setBackgroundColor:[UIColor yellowColor]];
    [bt setTitle:@"点我返回" forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(pushaction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bt];
    UIButton *brn = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 80, 80)];
    [self.view addSubview:brn];
    brn.backgroundColor = [UIColor blackColor];
    [brn addTarget:self action:@selector(tonext) forControlEvents:UIControlEventTouchUpInside];
    
    
}
- (void)tonext{
    
    ViewControllertwo *vc = [[ViewControllertwo alloc]init];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)pushaction{
    [self.navigationController popViewControllerAnimated:YES];
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
