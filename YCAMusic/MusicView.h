//
//  MusicView.h
//  YCAMusic
//
//  Created by yan on 16/3/14.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAMusicPlayerTool.h"

typedef void(^CloseViewBlock)();
@interface MusicView : UIView
{
    YCAMusicPlayerTool *player;
}
@property (nonatomic , strong) CloseViewBlock closeViewBlock;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;

-(void)initView;

- (IBAction)musicPauseAction:(id)sender;

- (IBAction)musicPlayAction:(id)sender;

- (IBAction)closeViewAction:(id)sender;

- (void)pauseMusic;

- (void)startMusic;

@end
