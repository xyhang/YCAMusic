//
//  AppDelegate.m
//  YCAMusic
//
//  Created by yan on 16/3/14.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "POP.h"
#import "YCAMusicPlayerTool.h"
#import "MusicView.h"
@interface AppDelegate (){
    UIBackgroundTaskIdentifier backID;
}

@property (nonatomic , strong)MusicView *musicView;

@end

@implementation AppDelegate

#pragma mark  shitu
-(void)initUI{
    _musicView = [[[NSBundle mainBundle]loadNibNamed:@"MusicView" owner:nil options:nil] lastObject];

    [_musicView initView];
    UIImage *moneyImg = IMG(@"money");
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT*3/4, 40, 40)];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn addTarget:self action:@selector(popMusicView) forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:moneyImg forState:UIControlStateNormal];
    [self.window addSubview:btn];
}

#pragma mark  关闭音乐播放器
-(void)closeMusiView
{
    _musicView.playBtn.hidden = YES;
    _musicView.pauseBtn.hidden = YES;
    __block CGFloat y = _musicView.frame.origin.y;
    __block CGFloat w = _musicView.frame.size.width;
    __block CGFloat h = _musicView.frame.size.height;
    [UIView animateWithDuration:1 animations:^{
       
        y+=SCREEN_HEIGHT*3/4-32;
        w-=SCREEN_WIDTH;
        h-=SCREEN_HEIGHT;

        _musicView.frame = CGRectMake(0, y, w, h);
        
    } completion:^(BOOL finished) {
        _musicView.frame = CGRectMake(0, y, w, h);
        _musicView.closeBtn.hidden = YES;
    }];

}


#pragma mark  弹出音乐播放器
-(void)popMusicView{
    _musicView.closeBtn.hidden = YES;
    _musicView.pauseBtn.hidden = YES;
    _musicView.playBtn.hidden = YES;
    [_musicView setFrame:CGRectMake(0, SCREEN_HEIGHT*3/4, 0, 0)];
    __weak typeof(self)weakSelf = self;
    [_musicView setCloseViewBlock:^(void){
        [weakSelf closeMusiView];
    }];
    [self.window addSubview:_musicView];
    
    __block CGFloat y =  _musicView.frame.origin.y;
    __block CGFloat w = _musicView.frame.size.width;
    __block CGFloat h = _musicView.frame.size.height;
    
    [UIView animateWithDuration:1 animations:^{
        if (y>0) {
            y-=SCREEN_HEIGHT*3/4-64;
        }
        if (w<SCREEN_WIDTH) {
            w+=SCREEN_WIDTH;
        }
        
        if (h<SCREEN_HEIGHT) {
            h+=SCREEN_HEIGHT-64;
        }
        [_musicView setFrame:CGRectMake(0, y, w, h)];
        
    } completion:^(BOOL finished) {
        _musicView.playBtn.hidden = NO;
        _musicView.pauseBtn.hidden = NO;
        _musicView.closeBtn.hidden = NO;
        [_musicView setFrame:CGRectMake(0, y, w, h)];
    }];
    
    POPSpringAnimation *anSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    
    [anSpring setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        
        if (finish) {
        }
    }];
    anSpring.springBounciness = 10.0f;
    [_musicView pop_addAnimation:anSpring forKey:@"position"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self.window makeKeyAndVisible];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    
    HomeViewController *hvc = [[HomeViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:hvc];
    self.window.rootViewController = nvc;
    
    [self initUI];

    DLOG(@"%@",self.window);
    
    
    return YES;
}

+(UIBackgroundTaskIdentifier)bcakGoundPlayerId:(UIBackgroundTaskIdentifier)backId{
    [[YCAMusicPlayerTool shareMusicPlayerTool] startBackGroundPlayer];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    UIBackgroundTaskIdentifier newTaskId = UIBackgroundTaskInvalid;
    newTaskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
    if (newTaskId != UIBackgroundTaskInvalid && backId != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:backId];
    }
    return newTaskId;
}
#pragma mark - 下一首
-(void)playNextMusic{
    [NOTIFICATIONCENTER postNotificationName:@"下一首" object:nil];
//    NSInteger count = dataArray.count;
//    if (row == count-1) {
//        row = 0;
//    }else{
//        row += 1;
//    }
//    
//    [self musicalStart];
//    
//    localMusicListModel *model = dataArray[row];
//    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
//    NSDictionary *dict = @{@"url":model.localMusicUrl};
//    [not postNotificationName:LOCALMUSICPLAY object:nil userInfo:dict];
}
#pragma mark - 上一首
-(void)playPreMusic{
    [NOTIFICATIONCENTER postNotificationName:@"上一首" object:nil];
}

#pragma mark - 暂停
-(void)pauseStreamer{
    [NOTIFICATIONCENTER postNotificationName:@"音乐暂停" object:nil];
}

-(void)startStreamer{
    [NOTIFICATIONCENTER postNotificationName:@"音乐播放" object:nil];
}

-(void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype)
        {
            case UIEventSubtypeRemoteControlPause:
                //点击了暂停
                [self pauseStreamer];
                break; case UIEventSubtypeRemoteControlNextTrack:
                //点击了下一首
                [self playNextMusic];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                //点击了上一首
                [self playPreMusic];
                //此时需要更改歌曲信息
                break;
            case UIEventSubtypeRemoteControlPlay:
                //点击了播放
                [self startStreamer];
                break;
            default:
                break;
        }
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    YCAMusicPlayerTool *tool = [YCAMusicPlayerTool shareMusicPlayerTool];
    [tool startBackGroundPlayer];
    
    backID = [AppDelegate bcakGoundPlayerId:backID];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
