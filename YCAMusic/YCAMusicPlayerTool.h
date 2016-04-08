//
//  YCAMusicPlayerTool.h
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
@interface YCAMusicPlayerTool : NSObject

@property (nonatomic , assign) BOOL isLocal;

@property (nonatomic , strong) AVPlayer *player;


@property (nonatomic , strong)  AVAudioSession *session;

+(YCAMusicPlayerTool *)shareMusicPlayerTool;
/**
 *  播放本地音乐
 *
 *  @param url 本地url
 */
-(void)playLocalMusicWith:(NSURL *)url;

/**
 *  播放网咯音乐
 *
 *  @param url url
 */
-(void)playOnlineMusicWith:(NSURL *)url;

/**
 *  暂停播放
 */
-(void)pauseMusic;

/**
 *  继续播放
 */
-(void)playMusic;

/**
 *  开启后台播放
 */
-(void)startBackGroundPlayer;
@end
