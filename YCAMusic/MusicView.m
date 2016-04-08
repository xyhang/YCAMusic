//
//  MusicView.m
//  YCAMusic
//
//  Created by yan on 16/3/14.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "MusicView.h"
#import "YCACircleView.h"

#define RADIUS 115
#define ICONWIDTH 170
#define ALLANGLE 350
@interface MusicView()
{
    NSString *musicPath;
    NSString *localMusicPath;
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic , strong) YCACircleView *ycaView;

@end

@implementation MusicView


-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
}

-(void)initView{
    
    player = [YCAMusicPlayerTool shareMusicPlayerTool];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.016 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isPlaying"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    
    if (_ycaView == nil) {
        [self createWtyViewWithCurrentTime:0 durationTime:1];
    }
    [self initNotifcation];
}

#pragma mark -  通知
-(void)initNotifcation{
    NSNotificationCenter *not = NOTIFICATIONCENTER;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sliderClick:) name:@"点击进度条" object:nil];
    [not addObserver:self selector:@selector(musicStart:) name:MUSICPLAY object:nil];
    [not addObserver:self selector:@selector(localMusicStart:) name:LOCALMUSICPLAY object:nil];
    [not addObserver:self selector:@selector(pauseMusic) name:@"音乐暂停" object:nil];
    [not addObserver:self selector:@selector(startMusic) name:@"音乐播放" object:nil];
}

#pragma mark - 进度条点击通知
- (void)sliderClick:(NSNotification *)noti
{
    // 改变播放进度
    
    int32_t timer = player.player.currentItem.asset.duration.timescale;
    Float64 timeValue = [noti.object[@"currentAngle"] doubleValue] * CMTimeGetSeconds(player.player.currentItem.duration) / ALLANGLE;
    [player.player seekToTime:CMTimeMakeWithSeconds(timeValue, timer) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    // 进度条显示
    [self.ycaView removeFromSuperview];
    [self createWtyViewWithCurrentTime:[noti.object[@"currentAngle"] intValue] durationTime:ALLANGLE];
    
    BOOL isplay = [[NSUserDefaults standardUserDefaults] boolForKey:@"isPlaying"];
    
    
    if (isplay == NO) {
        
        [player.player play];
        [self resumeTimer];
    }
    
}

#pragma mark - 定时器监听事件
- (void)timerStart
{
    CMTime durationTime = player.player.currentItem.duration;
   
    
    int duration = [[NSString stringWithFormat:@"%lf",CMTimeGetSeconds(durationTime)] intValue];
    int current = [[NSString stringWithFormat:@"%lf",CMTimeGetSeconds(player.player.currentItem.currentTime)] intValue];
    
    
    
    if (duration != 0) {
        
        [self.ycaView removeFromSuperview];
        
        [self createWtyViewWithCurrentTime:current durationTime:duration];
    }
    
}

#pragma mark - 暂停定时器
- (void)pausuTimer
{
    self.timer.fireDate = [NSDate distantFuture];
}

#pragma mark 恢复定时器
- (void)resumeTimer
{
    self.timer.fireDate = [NSDate distantPast];
}

#pragma mark - 创建进度条视图（WTYView）
- (void)createWtyViewWithCurrentTime:(int)currentTime durationTime:(int)durantionTime
{
    self.ycaView = [[YCACircleView alloc] initWithFrame:CGRectMake(0, 0, 115 * 2 + 15, 115 * 2 + 15)];
    self.ycaView.center = self.center;
    self.ycaView.backgroundColor = [UIColor clearColor];
    self.ycaView.currentTime = currentTime;
    self.ycaView.totalTime = durantionTime;
    self.ycaView.radious = 115;
    [self addSubview:self.ycaView];
}

#pragma mark - 播放本地音乐
-(void)localMusicStart:(NSNotification *)not{
    [player playLocalMusicWith:not.userInfo[@"url"]];
}

#pragma mark 播放网络音乐音乐
-(void)musicStart:(NSNotification*)not;
{
    musicPath = not.userInfo[@"url"];
    [player playOnlineMusicWith:[NSURL URLWithString:musicPath]];
}



- (IBAction)musicPauseAction:(id)sender {
    [player pauseMusic];
    [NOTIFICATIONCENTER postNotificationName:@"音符停止" object:nil];
    [self pausuTimer];
}

- (IBAction)musicPlayAction:(id)sender {
    [player playMusic];
    [self resumeTimer];
    [NOTIFICATIONCENTER postNotificationName:@"音符跳动" object:nil];

}

-(void)pauseMusic{
    [self pausuTimer];

    [player pauseMusic];
}

-(void)startMusic{
    [player playMusic];
    [self resumeTimer];
}

- (IBAction)closeViewAction:(id)sender {
    _closeViewBlock();
}
@end
