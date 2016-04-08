//
//  NetWorkMusicViewController.m
//  YCAMusic
//
//  Created by yan on 16/3/15.
//  Copyright © 2016年 yan. All rights reserved.
//

#import "NetWorkMusicViewController.h"
#import "MusicListTableViewCell.h"
#import "AFNetworking.h"
#import "MusicListModel.h"
#import "MusicListTableViewCell.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "YCAMusicPlayerTool.h"
@interface NetWorkMusicViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataArray;
    // 记录当前播放的音乐index.row
    NSInteger row;
    MusicListTableViewCell *cell;
    YCAMusicPlayerTool *tool;
}


@end

@implementation NetWorkMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    dataArray = [NSMutableArray array];
    
    [self loadData];
    
    [self initTableView];
    tool = [YCAMusicPlayerTool shareMusicPlayerTool];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(playEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(musicalStart) name:@"音符跳动" object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(musicalDisAppear) name:@"音符消失" object:nil];
    
    
    [NOTIFICATIONCENTER addObserver:self selector:@selector(playPreMusic) name:@"上一首" object:nil];
    [NOTIFICATIONCENTER addObserver:self selector:@selector(playNextMusic) name:@"下一首" object:nil];
}

#pragma mark - table初始化
-(void)initTableView{
    _myTableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self.view addSubview:_myTableView];
}

#pragma mark - table代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cell = [[[NSBundle mainBundle]loadNibNamed:@"MusicListTableViewCell" owner:nil options:nil]lastObject];
    [tableView dequeueReusableCellWithIdentifier:@"musicListCell"];
    MusicListModel *model = dataArray[indexPath.row];
    
    [cell createCellWithModel:model];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MusicListModel *model = dataArray[indexPath.row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.mp3Url};
   
    [self createDownLoadTaskWithURL:[NSURL URLWithString:model.mp3Url]];
    
    if(row != indexPath.row){
        // 暂时停止从头播放
        row = indexPath.row;
        [not postNotificationName:MUSICPLAY object:nil userInfo:dict];
        [not postNotificationName:@"音符消失" object:nil];
        [not postNotificationName:@"音符跳动" object:nil];
    }
    
}

#pragma mark - 音符跳动
-(void)musicalStart{
    [self.myTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [cell setSelected:YES];
}

#pragma mark - 音符停止
-(void)musicalDisAppear{
    cell = [self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row-1 inSection:0]];
    cell.animationView.hidden = YES;
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
    
    MusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.mp3Url};
    [not postNotificationName:MUSICPLAY object:nil userInfo:dict];
    [not postNotificationName:@"音符跳动" object:nil];
    
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
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 创建下载
-(void)createDownLoadTaskWithURL:(NSURL *)url{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionTask *task = [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:url] progress:nil destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        DLOG(@"%@",filePath);
    }];
    
    [task resume];
   
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
    
    MusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.mp3Url};
    if (!tool.isLocal) {
        [not postNotificationName:MUSICPLAY object:nil userInfo:dict];
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
    
    MusicListModel *model = dataArray[row];
    NSNotificationCenter *not = [NSNotificationCenter defaultCenter];
    NSDictionary *dict = @{@"url":model.mp3Url};
    if (!tool.isLocal) {
        [not postNotificationName:MUSICPLAY object:nil userInfo:dict];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
