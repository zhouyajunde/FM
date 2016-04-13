//
//  FMPlayer.h
//  Player
//
//  Created by bjsmit01 on 14-3-4.
//  Copyright (c) 2014年 Kevin Jin. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const KFMplayerStatusUpdata;
extern NSString *const KFMplayerTimerUpdate;

typedef NS_ENUM(NSInteger, FMplayerStatusCode)
{
    FMplayerStatus_StartBuffing = 0,
    FMplayerStatus_StopBufffing,
    FMplayerStatus_StartPlaying,
    FMplayerStatus_StopPlaying,
    FMplayerStatus_PausePlaying,
    FMplayerStatus_ErrorPlaying
};


@interface FMPlayer : UIView
{
    NSMutableArray *_listData;
    NSInteger _currentIndex;
}
@property(nonatomic, strong) NSString *currentUrl;
//@property(nonatomic, strong) NSMutableArray *listData;
//@property(nonatomic, assign) NSInteger currentIndex;

+ (instancetype)shareManager;

- (void)changeFrame:(CGRect)frame;

- (void)setPlayURL:(NSString *)url;

- (void)setListData:(NSMutableArray *)data index:(NSInteger)index;

- (void)stopPlay;

- (void)startPlay;

- (void)pausePlay;

- (void)nextPlay;

- (void)prePlay;

- (NSString *)getPlayTime;

- (BOOL)isPlaying;

@end
