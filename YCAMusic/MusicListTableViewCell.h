//
//  MusicListTableViewCell.h
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicListModel.h"


typedef void(^AnimationImgViewBlock)(id obj);

@interface MusicListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *musicIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicSingerLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *animationImgView;

@property (weak, nonatomic) IBOutlet UIImageView *animationView;


@property (nonatomic , strong) AnimationImgViewBlock animationBlock;

@property (nonatomic , strong) MusicListModel *model;

-(MusicListTableViewCell *)createCellWithModel:(MusicListModel *)model;

@end
