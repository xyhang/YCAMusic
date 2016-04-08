//
//  MusicListModel.h
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MusicListModel : NSObject
@property (nonatomic, copy) NSString *mp3Url;
@property (nonatomic, assign) NSNumber *idd;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *blurPicUrl;
@property (nonatomic, copy) NSString *album;
@property (nonatomic, copy) NSString *singer;
@property (nonatomic, assign) NSNumber *duration;
@property (nonatomic, copy) NSString *artists_name;
@property (nonatomic, copy) NSString *lyric;

+ (instancetype)modelWithDict:(NSDictionary *)dict;

@end
