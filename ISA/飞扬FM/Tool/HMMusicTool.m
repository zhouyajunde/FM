//
//  HMMusicTool.m
//  02-黑马音乐
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMMusicTool.h"
#import "scModel.h"
#import "MJExtension.h"

@implementation HMMusicTool
static NSArray *_musics,*_message;
static NSString *_shouCang;
static scModel *_playingMusic;

+(NSString *)shouCang
{
    if (_shouCang == nil) {
         _shouCang = @"无最近收藏";
        return _shouCang;

    }
    return _shouCang;
}

+(void)setshouCang:(NSString*)shoucang
{
    if (shoucang != nil) {
          _shouCang = shoucang;
    }
}

/**
 *  返回所有的歌曲
 */
+ (NSArray *)musics
{
    if (!_musics) {
//        _musics = [HMMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

+ (void)setAllMusic:(NSArray *)NarryMusic
{
    if (NarryMusic != nil) {
        _musics = NarryMusic;
    }
}
/**
 *  返回所以得聊天信息
 */
+(NSArray *)liaotianMessage
{
    if (!_message) {
        //        _musics = [HMMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _message;
}

+(void)setAllliaotianMessage:(NSArray *)NarryliaotianMessage
{
    if (NarryliaotianMessage != nil) {
        _message = NarryliaotianMessage;
    }

}


/**
 *  返回正在播放的歌曲
 */
+ (scModel *)playingMusic
{
    return _playingMusic;
}


+ (void)setPlayingMusic:(scModel *)playingMusic
{
//    if (!playingMusic || ![[self musics] containsObject:playingMusic]) return;
//    if (_playingMusic == playingMusic) return;
    
    _playingMusic = playingMusic;
} 
/**
 *  下一首歌曲
 */
+ (scModel *)nextMusic
{
    int nextIndex = 0;
    if (_playingMusic) {
        int playingIndex = [[self musics] indexOfObject:_playingMusic];
        nextIndex = playingIndex + 1;
        if (nextIndex >= [self musics].count) {
            nextIndex = 0;
        }
    }
    return [self musics][nextIndex];
}

/**
 *  上一首歌曲
 */
+ (scModel *)previousMusic
{
    int previousIndex = 0;
    if (_playingMusic) {
        int playingIndex = [[self musics] indexOfObject:_playingMusic];
        previousIndex = playingIndex - 1;
        if (previousIndex < 0) {
            previousIndex = [self musics].count - 1;
        }
    }
    return [self musics][previousIndex];
}
@end
