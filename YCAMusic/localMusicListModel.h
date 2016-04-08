//
//  localMusicListModel.h
//  YCAMusic
//
//  Created by yan on 16/3/19.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface localMusicListModel : NSObject

@property (nonatomic , copy) NSString *artist;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , strong) NSURL *localMusicUrl;



@end
