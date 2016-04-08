//
//  AnimationView.h
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;

-(void)startAnimation;

-(void)endAnimation;

@end
