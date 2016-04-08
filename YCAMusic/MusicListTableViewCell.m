//
//  MusicListTableViewCell.m
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation MusicListTableViewCell

- (void)awakeFromNib {

    _musicIconImageView.layer.cornerRadius = 45;
    _musicIconImageView.layer.masksToBounds = YES;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 1; i<16; i++) {
        [imgArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"gif48_%d",i]]];
    }
    self.animationView.animationImages = imgArr;
    self.animationView.animationDuration = 2;
    self.animationView.animationRepeatCount = 0;
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(endAnimation) name:@"音符停止" object:nil];
}



-(void)startAnimation{
    DLOG(@"%@",self);
    DLOG(@"%@",_animationView);
    self.animationView.hidden = NO;
    [self.animationView startAnimating];
}

-(void)endAnimation{
    [self.animationView stopAnimating];
    self.animationView.image = [UIImage imageNamed:@"gif48_1000"];
}


-(MusicListTableViewCell *)createCellWithModel:(MusicListModel *)model
{
    [_musicIconImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl]];
    _musicNameLabel.text = model.name;
    _animationView.hidden = YES;
    _musicSingerLabel.text = [NSString stringWithFormat:@"%@-%@",model.singer,model.name];
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
   
    if (selected) {
        [self startAnimation];
    }else{
        
    }
    // Configure the view for the selected state
}

@end
