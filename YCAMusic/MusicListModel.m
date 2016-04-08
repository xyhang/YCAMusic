//
//  MusicListModel.m
//  YCAMusic
//
//  Created by yan on 16/3/16.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "MusicListModel.h"

@implementation MusicListModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idd = value;
    }
}

@end
