//
//  LocalMusicTableViewController.m
//  YCAMusic
//
//  Created by yan on 16/3/15.
//  Copyright © 2016年 yan. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import "LocalMusicTableViewController.h"
#import "LocalMusicTableViewCell.h"
#import "AFNetworking.h"
#import "localMusicListModel.h"
#import "MusicListTableViewCell.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "YCAMusicPlayerTool.h"
@interface LocalMusicTableViewController (){
    NSMutableArray *dataArray;
    // 记录当前播放的音乐index.row
    NSInteger row;
    YCAMusicPlayerTool *tool;
}

@property (nonatomic , strong)AFHTTPSessionManager *manager;
@property (nonatomic , strong)LocalMusicTableViewCell *localMusicCell;

@end

@implementation LocalMusicTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self queryAllMusic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tool = [YCAMusicPlayerTool shareMusicPlayerTool];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(localViewShow) name:@"本地" object:nil];
    dataArray = [NSMutableArray array];
//
//    [self loadData];
//    
//    [NOTIFICATIONCENTER addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(playPreMusic) name:@"上一首" object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(playNextMusic) name:@"下一首" object:nil];
    
}
#pragma mark - 视图显示
-(void)localViewShow{
    [dataArray removeAllObjects];
    [self queryAllMusic];
    [self.tableView layoutIfNeeded];
}

#pragma mark - 加载数据
-(void)loadData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MusicInfoList" ofType:@"plist"];
    NSArray *arr = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *musicItem in arr) {
        MusicListModel *model = [MusicListModel modelWithDict:musicItem];
        [dataArray addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - 扫描本地歌曲
-(void)queryAllMusic
{
    NSArray *filePathArr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *fileArr = [fileManager contentsOfDirectoryAtPath:filePathArr[0] error:&error];
    DLOG(@"%@",error);
    for (int i = 0;i<fileArr.count;i++) {
        NSString *filePath = fileArr[i];
        NSURL *fileUrl = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@",filePathArr[0],filePath]];
      localMusicListModel *model = [self getMusicInfoWithUrl:fileUrl];
        [dataArray addObject:model];
    }
    [self.tableView reloadData];

}
#pragma mark - 获取音乐信息
-(localMusicListModel *)getMusicInfoWithUrl:(NSURL *)fileUrl{
    localMusicListModel *model = [[localMusicListModel alloc]init];
    model.localMusicUrl = fileUrl;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:fileUrl options:nil];
    for (NSString *info in [asset availableMetadataFormats]) {
        for (AVMetadataItem *metadataItem in [asset metadataForFormat:info]) {
//            DLOG(@"%@----%@",metadataItem.commonKey,metadataItem.value);
//            model.title = metadataItem.value;
            if ([metadataItem.commonKey isEqualToString:@"title"]) {
                model.title = (NSString *)metadataItem.value;
            }
            if ([metadataItem.commonKey isEqualToString:@"artist"]) {
                model.artist = (NSString *)metadataItem.value;
            }
            DLOG(@"%@--%@",metadataItem.commonKey, metadataItem.value);
//            break;
        }
    }
    return model;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        
    }
    localMusicListModel *model = dataArray[indexPath.row];
    
    cell.textLabel.text = (model.title == nil)?  @"未获取到" : model.title;
    cell.detailTextLabel.text = model.artist;
    
    
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 110;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    localMusicListModel *model = dataArray[indexPath.row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.localMusicUrl};
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:model.mp3Url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        DLOG(@"%@",downloadProgress);
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        DLOG(@"%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        DLOG(@"%@",error.description);
//    }];
    
    if(row != indexPath.row || indexPath.row == 0){
        // 暂时停止从头播放
        row = indexPath.row;
        [not postNotificationName:LOCALMUSICPLAY object:nil userInfo:dict];
    }
    
}

#pragma mark - 音符跳动
-(void)musicalStart{
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setSelected:YES];
}

#pragma mark - 音符停止
-(void)musicalDisAppear{
//    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0]];
//    cell.animationView.hidden = YES;
}

#pragma mark - 播放完成
-(void)playEnd
{
    BOOL cyclePlay = [USER_DEFAULT boolForKey:@"cyclePlay"];
    NSInteger count = dataArray.count;
    if (cyclePlay) {
        // 单曲循环
        
        
    }
    // 列表循环
    if (row == count-1) {
        row = 0;
    }else{
        row += 1;
    }
    
    [self musicalStart];
    
    localMusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.localMusicUrl};
    [not postNotificationName:LOCALMUSICPLAY object:nil userInfo:dict];
}

#pragma mark - 下一首
-(void)playNextMusic{
    NSInteger count = dataArray.count;
    if (row == count-1) {
        row = 0;
    }else{
        row += 1;
    }
    
    [self musicalStart];
    
    localMusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.localMusicUrl};
    if (tool.isLocal) {
        [not postNotificationName:LOCALMUSICPLAY object:nil userInfo:dict];
    }
}
#pragma mark - 上一首
-(void)playPreMusic{
    if (row == 0) {
        row = 0;
    }else{
        row -= 1;
    }
    
    [self musicalStart];
    
    localMusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.localMusicUrl};
    if (tool.isLocal) {
        [not postNotificationName:LOCALMUSICPLAY object:nil userInfo:dict];
    }
}



@end
