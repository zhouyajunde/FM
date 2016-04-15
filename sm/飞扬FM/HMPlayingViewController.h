//
//  HMPlayingViewController.h
//  02-黑马音乐
//
//  Created by apple on 14-8-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "scModel.h"
#import "ZYJdic.h"

@interface HMPlayingViewController : UIViewController



@property(nonatomic,strong)scModel *musicList;

+(instancetype)musicView;

- (void)show;

- (BOOL)isPlaying;
@end
