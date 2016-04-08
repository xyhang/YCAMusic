
//
//  YCAMusicPlayerTool.m
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "YCAMusicPlayerTool.h"
@interface YCAMusicPlayerTool()



@end


@implementation YCAMusicPlayerTool

@synthesize player;
@synthesize session;

+(YCAMusicPlayerTool *)shareMusicPlayerTool{
    static YCAMusicPlayerTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[self alloc]init];
    });
    return tool;
}

-(void)startBackGroundPlayer{
    session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

-(void)playLocalMusicWith:(NSURL *)url
{
    self.isLocal = YES;
    if (session) {
        session = nil;
    }
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    player = [[AVPlayer alloc]initWithPlayerItem:item];
    [player setRate:2];
    
    [player play];
}

-(void)playOnlineMusicWith:(NSURL *)url
{
    self.isLocal = NO;
    
    session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:url];
    player = [[AVPlayer alloc]initWithPlayerItem:item];
    [player setRate:2];
    
    [player play];
    
    
}


-(void)playMusic
{
    [player play];
}
-(void)pauseMusic{
    
    [player pause];
}


@end
