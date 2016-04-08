//
//  AnimationView.m
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "AnimationView.h"

@implementation AnimationView

-(void)awakeFromNib{
    
    self.animationImgView.layer.cornerRadius = 30;
    self.animationImgView.layer.masksToBounds = YES;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 1; i<16; i++) {
        [imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gif48_%d",i]]];
    }
    self.animationImgView.animationImages = imgArr;
    self.animationImgView.animationDuration = 2;
    self.animationImgView.animationRepeatCount = 0;

}

-(void)startAnimation{
    DLOG(@"%@",self);
    DLOG(@"%@",_animationImgView);
    self.animationImgView.hidden = NO;
    [self.animationImgView startAnimating];
}

-(void)endAnimation{
    [self.animationImgView stopAnimating];
    self.animationImgView.image = [UIImage imageNamed:@"gif48_1000"];
}

@end
