//
//  FMPlayer.m
//  Player
//
//  Created by bjsmit01 on 14-3-4.
//  Copyright (c) 2014年 Kevin Jin. All rights reserved.
//

#import "FMPlayer.h"
#import "SIChannelInfoEntity.h"
#import "Vitamio.h"
#import "SIShowInfoEntity.h"
#import "SIPlayViewController.h"
#import <QuartzCore/QuartzCore.h>

NSString *const KFMplayerStatusUpdata = @"KFMplayerStatusUpdataNotification";
NSString *const KFMplayerTimerUpdate = @"KFMplayerTimerUpdateNofitication";

@interface FMPlayer ()<VMediaPlayerDelegate>
{
    VMediaPlayer *_vPlayer;
    long     mDuration;
    long     mCurPostion;
    NSTimer  *timer;
    NSMutableArray *_showArray;
    BOOL isUpdateUI;
    BOOL canPlay;
    BOOL isCountDownFlag;
}

- (void)getShowInfo;

@end

@implementation FMPlayer
//@synthesize listData= _listData;
//@synthesize currentIndex = _currentIndex;

+ (instancetype)shareManager
{
    static FMPlayer *fmPlayer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fmPlayer = [[FMPlayer alloc] initWithFrame:CGRectZero];
    });
    return fmPlayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _vPlayer = [VMediaPlayer sharedInstance];
        [_vPlayer setupPlayerWithCarrierView:self withDelegate:self];
        
        self.layer.cornerRadius = 4.0;
        self.layer.masksToBounds = YES;

        //_listData = [NSMutableArray arrayWithCapacity:10];
        
        _showArray = [NSMutableArray arrayWithCapacity:10];
        isUpdateUI = NO;
        isCountDownFlag = NO;
        
        [self addView];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopFM) name:@"STOPFM" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startFM) name:@"STARTFM" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFlag) name:@"startUpdata" object:nil];
        
        /**
         *  ADD 倒计时相关
         */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:@"CHANGE_PLAYER_STATUS" object:nil];
        
        /**
         *  ADD 增加手势
         */
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sentMessage:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)stopFM
{
    UIButton *temp = (UIButton *)[self viewWithTag:100000];
    temp.selected = YES;
    
    //reset timer
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)startFM
{
    UIButton *temp = (UIButton *)[self viewWithTag:100000];
    temp.selected = NO;
    
    //timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)changeFlag
{
    //当小播放器暂停，进入播放页，如果为同一个节目，那么小播放器要开启刷新。
    DBLog(@"这里应该可以刷新了!");
    isUpdateUI = YES;
    
    UIButton *temp = (UIButton *)[self viewWithTag:100000];
    temp.selected = NO;
    
    
}

- (void)addView
{
    //modify 2014-8-9
    
    /*
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    timeLabel.text = @"00:00:00";
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.tag = 999;
    timeLabel.backgroundColor = CLEAR_COLOR;
    [self addSubview:timeLabel];
     */
    
    UILabel *fmLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, 80, 20)];
    fmLabel.font = [UIFont systemFontOfSize:15];
    fmLabel.textAlignment = NSTextAlignmentLeft;
    fmLabel.tag = 666;
    fmLabel.backgroundColor = CLEAR_COLOR;
    [self addSubview:fmLabel];

    
    UILabel *carLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 20, 110, 30)];
    carLabel.textAlignment = NSTextAlignmentLeft;
    carLabel.font = [UIFont systemFontOfSize:14];
    //carLabel.text = @"汽车音乐风";
    carLabel.tag = 888;
    carLabel.backgroundColor = CLEAR_COLOR;
    [self addSubview:carLabel];
    
    /*
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(150, 26, 29, 18);
    [preBtn setBackgroundImage:[UIImage imageNamed:@"pre_btn"] forState:UIControlStateNormal];
    preBtn.showsTouchWhenHighlighted = YES;
    [preBtn addTarget:self action:@selector(prePlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:preBtn];
     */
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    playBtn.frame = CGRectMake(205, 21, 29, 29);
    if (flag == 0) {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"bfzn_004"] forState:UIControlStateNormal];
    }else{
        [playBtn setBackgroundImage:[UIImage imageNamed:@"bfzn_003"] forState:UIControlStateNormal];
    }
    playBtn.showsTouchWhenHighlighted = YES;
    playBtn.selected = NO;
    playBtn.tag = 100000;
    [playBtn addTarget:self action:@selector(playOrPause:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(250, 21, 29, 29);
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"bfzn_007"] forState:UIControlStateNormal];
    nextBtn.showsTouchWhenHighlighted = YES;
    [nextBtn addTarget:self action:@selector(nextPlay) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
}


- (void)changeFrame:(CGRect)frame
{

    //self.frame = ;
    
    self.frame = frame;
    self.backgroundColor = RGB_COLOR(212, 222, 222);
    
    if (frame.size.height == 0 && frame.size.width == 0) {
        
        if ([timer isValid]) {
            [timer invalidate];
            //NSLog(@"&&&&&&&&&&&&&&&&&&&&");
        }
        
    }else{
        if ([timer isValid]) {
            
        }else{
            UIButton *temp = (UIButton *)[self viewWithTag:100000];
            if (temp.selected == YES) {
                
            }else{
                //timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
            }
        }
    }
}


#pragma mark - method

- (void)setPlayURL:(NSString *)url
{
    
    int t = [[[NSUserDefaults standardUserDefaults] objectForKey:@"3G"]intValue];

    if (t == 0 && isWWAN) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前您正处于2G/3G网络下，收听会产生流量，建议WIFI下收听。" delegate:nil cancelButtonTitle:@"继续收听" otherButtonTitles:@"取消", nil];
        [alert showAlertViewWithFinishBlock:^(NSInteger buttonIndex) {
            
            if (buttonIndex == 0) {
                
                [_vPlayer reset];
                
                [_vPlayer setDataSource:[NSURL URLWithString:url]];
                [_vPlayer prepareAsync];
                
                self.currentUrl = url;
                
                canPlay = NO;
                
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"3G"];

            }else{
            
                DBLog(@"用户取消了收听!");
            }
            
        }];
    }else{
    
        DBLog(@"wifi or use 3g~~");
        [_vPlayer reset];
        
        [_vPlayer setDataSource:[NSURL URLWithString:url]];
        [_vPlayer prepareAsync];
        
        self.currentUrl = url;
        
        canPlay = NO;
        
    
    }
    
 //   [self performSelector:@selector(canNotPlay) withObject:nil afterDelay:10];

}

- (void)canNotPlay
{
    if (canPlay == NO) {
        
        //post notification
        [[NSNotificationCenter defaultCenter] postNotificationName:@"cannotplay" object:nil];
        
    }else{
        //
        
    }

}



- (void)setListData:(NSMutableArray *)data index:(NSInteger)index
{
    if (_listData.count != 0) {
        [_listData removeAllObjects];
    }
    _listData = [data mutableCopy];
    _currentIndex = index;
    
    
    //first set  fm name
    isUpdateUI = NO;
    [self setFMName];
    [self getShowInfo];
}

- (void)playOrPause:(UIButton *)btn
{
    /**
     *  增减判断，当再次点击小播放器的开始按钮式继续播放当前的。
     */
    
    
    if (isCountDownFlag == YES) {
        
        [self setPlayURL:self.currentUrl];
        
        isUpdateUI = YES;
        
//        if (![timer isValid]) {
//            
//            timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//        }

        
        isCountDownFlag = NO;
    }else{
    
        if (btn.selected == NO) {
            [self pausePlay];
            btn.selected = YES;
            isUpdateUI = NO;
            [btn setBackgroundImage:[UIImage imageNamed:@"bfzn_003"] forState:UIControlStateNormal];

        }else{
            [self startPlay];
            btn.selected = NO;
            isUpdateUI = YES;
            [btn setBackgroundImage:[UIImage imageNamed:@"bfzn_004"] forState:UIControlStateNormal];

//            if (![timer isValid]) {
//            
//                timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//            }
            
        }
    }
}


- (void)startPlay
{
    [_vPlayer start];
}

- (void)stopPlay
{
    if ([_vPlayer isPlaying]) {
        [_vPlayer reset];
    }
}

- (void)pausePlay
{
    [_vPlayer pause];
}

- (void)prePlay
{
    //有用
    if (_currentIndex > 0) {
        _currentIndex -=1;
        NSString *url = [(SIChannelInfoEntity *)_listData[_currentIndex] channelURL];
        NSLog(@"url=====%@",url);
        self.currentUrl = url;
        //[self setPlayURL:url];
        
        //add set fm name
         isUpdateUI = NO;
         [self setFMName];
         //[self getShowInfo];
        
        [self getNewShowInfo];
    }
  
    
    
}

- (void)nextPlay
{
    //有用
    if (_currentIndex < (_listData.count-1) ) {
        _currentIndex +=1;
        NSString *url = [(SIChannelInfoEntity *)_listData[_currentIndex] channelURL];
        NSLog(@"url====%@",url);
        self.currentUrl = url;
        //[self setPlayURL:url];
        
        
        ///add set fm name
        isUpdateUI = NO;
        [self setFMName];
        //[self getShowInfo];
        [self getNewShowInfo];
        
        //更改暂停按钮的图标
        
        UIButton *temp = (UIButton *)[self viewWithTag:100000];
        [temp setBackgroundImage:[UIImage imageNamed:@"bfzn_004"] forState:UIControlStateNormal];
        temp.selected = NO;
    }
    
}

#pragma mark VMediaPlayerDelegate Implement / Required

- (void)mediaPlayer:(VMediaPlayer *)player didPrepared:(id)arg
{
    canPlay = YES;
    //开始播放
	mDuration = [_vPlayer getDuration];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_vPlayer start];
    });
    
    //通知 开始更新时间显示。//stop indicator
    FMplayerStatusCode code = FMplayerStatus_StartPlaying;
    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
}

- (void)mediaPlayer:(VMediaPlayer *)player playbackComplete:(id)arg
{
	//播放完成，发送消息
    
}

- (void)mediaPlayer:(VMediaPlayer *)player error:(id)arg
{
    FMplayerStatusCode code = FMplayerStatus_ErrorPlaying;
    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
    
}

#pragma mark VMediaPlayerDelegate Implement / Optional

- (void)mediaPlayer:(VMediaPlayer *)player setupManagerPreference:(id)arg
{
    //配置信息
	player.decodingSchemeHint = VMDecodingSchemeSoftware;
	player.autoSwitchDecodingScheme = NO;
}

- (void)mediaPlayer:(VMediaPlayer *)player setupPlayerPreference:(id)arg
{
	//设置buffer
	[_vPlayer setBufferSize:20*1024];
    [player setAdaptiveStream:YES];
	player.useCache = NO;

}

- (void)mediaPlayer:(VMediaPlayer *)player seekComplete:(id)arg
{
    
}

- (void)mediaPlayer:(VMediaPlayer *)player notSeekable:(id)arg
{
	NSLog(@"NAL 1HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingStart:(id)arg
{
	NSLog(@"NAL 2HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    //NSLog(@"开始缓冲~~~~");
    FMplayerStatusCode code = FMplayerStatus_StartBuffing;
    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingUpdate:(id)arg
{
    NSLog(@"缓冲进度=====%d%%",[(NSNumber *)arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player cacheNotAvailable:(id)arg
{

     NSLog(@"acheNotAvailable");
}

- (void)mediaPlayer:(VMediaPlayer *)player bufferingEnd:(id)arg
{
	NSLog(@"NAL 3HBT &&&&&&&&&&&&&&&&.......&&&&&&&&&&&&&&&&&");
    //NSLog(@"缓冲完毕，开始播放~");
    
//    [_vPlayer start];
//    FMplayerStatusCode code = FMplayerStatus_StartBuffing;
//    NSDictionary *data = @{@"status":[NSNumber numberWithInteger:code]};
//    [[NSNotificationCenter defaultCenter] postNotificationName:KFMplayerStatusUpdata object:nil userInfo:data];
    
}

- (void)mediaPlayer:(VMediaPlayer *)player downloadRate:(id)arg
{
    NSLog(@"当前网速==%dKB/s",[arg intValue]);
}

- (void)mediaPlayer:(VMediaPlayer *)player videoTrackLagging:(id)arg
{
    	NSLog(@"NAL 1BGR video lagging....");
}

- (NSString *)getPlayTime
{
    mCurPostion  = [_vPlayer getCurrentPosition];
    unsigned long seconds, h, m, s;
    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = mCurPostion / 1000;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
    nsRet = [[NSString alloc] initWithCString:buff
                                     encoding:NSUTF8StringEncoding];
    
    return nsRet;
}

/*
- (void)updateTimer
{
    UILabel *timeLabel = (UILabel *)[self viewWithTag:999];
   // UILabel *nameLabel = (UILabel *)[self viewWithTag:888];
    
    if (isUpdateUI) {
        if (_showArray.count != 0) {
            [self setTitleandTime];
        }else{
            timeLabel.text = @"00:00:00";
        }
    }
    
//    //
//    NSString *timeStr = [self getPlayTime];
//    if ([[timeStr componentsSeparatedByString:@":"][0] intValue] > 10) {
//        timeLabel.text = @"00:00:00";
//    }else{
//        timeLabel.text = timeStr;
//    }
}
*/
#pragma mark - set now time and title
- (void)setTitleandTime
{
    
    NSString * nowTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd HH:mm:ss"];
    int hour = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] firstObject] intValue];
    int min = [[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] [1] intValue];
    int sec = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] lastObject] intValue];
    
    float temp = [[NSString stringWithFormat:@"%d.%d",hour,min] floatValue];
    
    UILabel *timeLabel = (UILabel *)[self viewWithTag:999];
    
    
    for (int i = 0; i < _showArray.count; i++) {
        int stime = [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] firstObject] intValue];
        int sMtime =  [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] lastObject] intValue];
        
        float tempStart = [[NSString stringWithFormat:@"%d.%d",stime,sMtime] floatValue];

        
        int etime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] firstObject] intValue];
        int eMtime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] lastObject] intValue];
        
        float tempEnd = [[NSString stringWithFormat:@"%d.%d",etime,eMtime] floatValue];

        
        if (temp >=tempStart && temp <= tempEnd) {
            
            
            //倒计时时间
            int lastHour = (etime*3600+eMtime*60-hour*3600-min*60-sec)/3600;
            int lastMin = (etime*3600+eMtime*60-hour*3600-min*60-sec)%3600/60;
            int lastSec = (etime*3600+eMtime*60-hour*3600-min*60-sec)%3600%60;
            timeLabel.text = [NSString stringWithFormat:@"%d:%d:%d",lastHour,lastMin,lastSec];
        }
    }
    
}

- (void)getShowInfo
{
    if (_showArray.count != 0) {
        [_showArray removeAllObjects];
    }
    
    NSString *cid = [_listData[_currentIndex] channelID];
//    DBLog(@"=======%@",cid);
    NSDictionary *parameter = @{@"channelid":cid};
    
    [[HTTPManager shareManager] postPath:CHANNEL_JMD_URI parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
//        DBLog(@"jsonobj=%@",jsonObj);
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                SIShowInfoEntity *item = [[SIShowInfoEntity alloc] initWithData:data];
                [_showArray addObject:item];
                item = nil;
            }
            
        }else{
            
            
        }
        
        // [self setTitleandTime];
        isUpdateUI = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];
}


#pragma mark --- set name
- (void)setFMName
{
    //这里设置 小播放器的电台名字
    UILabel *nameLabel = (UILabel *)[self viewWithTag:888];
    nameLabel.text = [_listData[_currentIndex] channelName];
    
    UILabel *fmLabel = (UILabel *)[self viewWithTag:666];
    fmLabel.text = [_listData[_currentIndex] channelFm];


}


#pragma mark - get new show info
- (void)getNewShowInfo{
    
    
    if (_showArray.count != 0) {
        [_showArray removeAllObjects];
    }
    
    NSString *cid = [_listData[_currentIndex] channelID];
    DBLog(@"=======%@",cid);
    NSDictionary *parameter = @{@"channelid":cid};
    
    [[HTTPManager shareManager] postPath:CHANNEL_JMD_URI parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        DBLog(@"jsonobj=%@",jsonObj);
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                SIShowInfoEntity *item = [[SIShowInfoEntity alloc] initWithData:data];
                [_showArray addObject:item];
                item = nil;
            }
            
        }else{
            
            
        }
        
        // [self setTitleandTime];
        isUpdateUI = YES;
        
        // 对比时间，是否有节目。
        
        BOOL hasShow = NO;
        NSString * nowTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd HH:mm:ss"];
        int hour = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] firstObject] intValue];
        int min = [[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] [1] intValue];
        
        float temp = [[NSString stringWithFormat:@"%d.%d",hour,min] floatValue];
        
        
        
        for (int i = 0; i < _showArray.count; i++) {
            int stime = [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] firstObject] intValue];
            int sMtime =  [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] lastObject] intValue];
            
            float tempStart = [[NSString stringWithFormat:@"%d.%d",stime,sMtime] floatValue];
            
            int etime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] firstObject] intValue];
            int eMtime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] lastObject] intValue];
            
            float tempEnd = [[NSString stringWithFormat:@"%d.%d",etime,eMtime] floatValue];
            
            
            
            if (temp >=tempStart && temp <= tempEnd) {
                
                hasShow = YES;
            }
        }
        
        if (hasShow) {
            
            [self setPlayURL:self.currentUrl];

            
        }else{
            
            [self stopPlay];
            
            UILabel *timeLabel = (UILabel *)[self viewWithTag:999];
            timeLabel.text = @"00:00:00";
            DBLog(@"没有节目哦!");
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];
    
}

- (void)changeStatus:(NSNotification *)noti
{
    DBLog(@"改变播放器的状态。按钮状态~~");
    
    UIButton *btn = (UIButton *)[self viewWithTag:100000];
    
    btn.selected = NO;
    isCountDownFlag = YES;
    isUpdateUI = NO;
    
    if (btn.selected == NO) {
        DBLog(@"显示开始的按钮~");
        [btn setImage:[UIImage imageNamed:@"fy_channelplay_radio"] forState:UIControlStateNormal];
    }
    
}


- (BOOL)isPlaying
{
    if ([_vPlayer isPlaying]) {
        return YES;
    }
    return NO;
}

- (void)sentMessage:(UITapGestureRecognizer *)tap
{
    UINavigationController *vc = [self viewController];
    
    DBLog(@"hello world====%@",vc);
    
    SIPlayViewController *playercontroller = [[SIPlayViewController alloc] initWithData:_listData index:_currentIndex];
    playercontroller.isPlay = @"Yes";
    [vc pushViewController:playercontroller animated:YES];


    
}

- (UINavigationController*)viewController {
    
    for (UIView* next = [self superview]; next; next =
         next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UINavigationController
                                         class]]) {
            return (UINavigationController*)nextResponder;
        }
    }
    return nil;
}

@end
