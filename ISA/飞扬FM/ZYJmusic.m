//
//  ZYJmusic.m
//  01-ItcastLottery
//
//  Created by Mac os on 16/2/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import "ZYJmusic.h"
#import "HMPlayingViewController.h"
#import "JingRoundView.h"
#import "HMMusicTool.h"
#import "MJExtension.h"
#import "UIImageView+header.h"
#import "UserDefine.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD+NJ.h"

static BOOL flag = NO;

@interface ZYJmusic ()<JingRoundViewDelegate>
{
    UIImage *im;
}

@property (nonatomic, strong) scModel *playingMusic;
@property (nonatomic, strong) UIImageView *bacImg;

@property (weak, nonatomic) IBOutlet JingRoundView *roundView;
@property (weak, nonatomic) IBOutlet UILabel *jiemuLab;
@property (weak, nonatomic) IBOutlet UIButton *pauseLab;
- (IBAction)pauseBtn:(id)sender;
- (IBAction)nextBtn:(id)sender;

@end

@implementation ZYJmusic

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
           }
    return self;
}

-(id)init
{
    self=[[[NSBundle mainBundle]loadNibNamed:@"ZYJmusic" owner:nil options:nil] firstObject];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"tongzhi" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kaishi:) name:@"kaishi" object:nil];
    if (self) {
        
        _roundView.delegate = self;
        _roundView.rotationDuration = 12.0;
        _roundView.isPlay = flag;
        
        self.roundView.roundImageView.image = [UIImage imageNamed:@"diantai_default.png"];
    }
    
    return self;
}

- (void)tongzhi:(NSNotification *)text{
  
    NSLog(@"%@",text.userInfo);
    NSLog(@"－－－－－接收到通知------");
    
    self.playingMusic = [scModel mj_objectWithKeyValues:text.userInfo];
    
    self.jiemuLab.text = self.playingMusic.name;
    
            UIImage *placeholder = [UIImage imageNamed:@"diantai_default.png"];
    
            // 下载图片
    
            NSString *filrfileURL = zongdizhiURL;
    
            NSString *urlStr = [filrfileURL stringByAppendingString:[NSString stringWithFormat:@"%@",self.playingMusic.img]];
    
    [self.roundView.roundImageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:placeholder];

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    HMPlayingViewController *music = [HMPlayingViewController musicView];

    [self.delegate touch:music];
}
- (void)dealloc
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)kaishi:(NSNotification *)text{
    
    NSLog(@"%@",text.userInfo);
    NSLog(@"－－－－－接收到通知------");

    NSDictionary *dic = [NSDictionary dictionary];
    
    dic = text.userInfo;
    
    if (![[dic objectForKey:@"isPlaying"] boolValue]) {
        flag = NO;
         _roundView.isPlay = YES;
        [_pauseLab setImage:[UIImage imageNamed:@"player_window_status_btn"] forState:UIControlStateNormal];
    }else
    {
         flag = YES;
        _roundView.isPlay = NO;
        [_pauseLab setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];
     
    }
}


- (IBAction)pauseBtn:(id)sender {
    
    NSNotification *notification =[NSNotification notificationWithName:@"playOrPause" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    if ([HMMusicTool playingMusic] == nil) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"您还没有收听"];
        _roundView.isPlay = NO;
        [_pauseLab setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];
        
        return;
    }
    
    if (flag) {
        _roundView.isPlay = NO;
        
        [_pauseLab setImage:[UIImage imageNamed:@"player_status_btn"] forState:UIControlStateNormal];
        flag = NO;
    } else {
        _roundView.isPlay = YES;
        [_pauseLab setImage:[UIImage imageNamed:@"player_window_status_btn"] forState:UIControlStateNormal];
        flag = YES;
    }
}

- (IBAction)nextBtn:(id)sender {
    NSNotification *notification =[NSNotification notificationWithName:@"nextMUS" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}
@end
