//
//  HomeViewController.m
//  YCAMusic
//
//  Created by yan on 16/3/14.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "HomeViewController.h"
#import "RankMusicViewController.h"
#import "LocalMusicTableViewController.h"
#import "NetWorkMusicViewController.h"
@interface HomeViewController ()
{
    LocalMusicTableViewController *lvc;
    NetWorkMusicViewController *nvc;
    RankMusicViewController *rvc;
}
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initChildVC];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = [self createSegementControl];
}
#pragma mark -  子VC初始化
-(void)initChildVC
{
    lvc = [[LocalMusicTableViewController alloc]initWithNibName:@"LocalMusicTableViewController" bundle:nil];
    nvc = [[NetWorkMusicViewController alloc]initWithNibName:@"NetWorkMusicViewController" bundle:nil];
    rvc = [[RankMusicViewController alloc]initWithNibName:@"RankMusicViewController" bundle:nil];
    lvc.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    rvc.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    nvc.view.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    
    [self addChildViewController:lvc];
    [self addChildViewController:nvc];
    [self addChildViewController:rvc];
    
    [self.view addSubview:lvc.view];

}

#pragma mark - 生成segementControl
-(UISegmentedControl *)createSegementControl
{
    UISegmentedControl *segementC = [[UISegmentedControl alloc]initWithItems:@[@"本地",@"网络",@"排行"]];
    segementC.tintColor = [UIColor whiteColor];
    segementC.layer.borderColor = [UIColor whiteColor].CGColor;
    segementC.layer.shadowColor = [UIColor whiteColor].CGColor;
    segementC.layer.masksToBounds = YES;
    segementC.layer.cornerRadius = 10;
    segementC.backgroundColor = [UIColor greenColor];
    segementC.frame = CGRectMake(0, 34, 140, 30);
    segementC.selectedSegmentIndex = 0;
    [segementC addTarget:self action:@selector(segementControlClick:) forControlEvents:UIControlEventValueChanged];
    return segementC;
}
#pragma mark - 分段控制器选择
-(void)segementControlClick:(UISegmentedControl*)sender
{
    DLOG(@"%ld",sender.selectedSegmentIndex);
    for (UIView *tempV in self.view.subviews) {
        [tempV removeFromSuperview];
    }
    switch (sender.selectedSegmentIndex) {
        case 0:
            // 本地
            [self.view addSubview:lvc.view];
            [NOTIFICATIONCENTER postNotificationName:@"本地" object:nil];
            break;
        case 1:
            DLOG(@"%@",nvc.view);
            [self.view addSubview:nvc.view];
            break;
        case 2:
            DLOG(@"%@",rvc.view);
            [self.view addSubview:rvc.view];
            break;
        
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
