//
//  SISettingViewController.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 14-3-3.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SISettingViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "HTTPManager.h"
#import "SISettingInfoViewController.h"

#define TAG_BUTTON        71000
#define TAG_CLOSEBUTTON   72001
#define TAG_OPENBUTTON    72002
#define TAG_TIMINGBUTTON  73000
#define TAG_GONextbutton  74000
#define TAG_LEFTIMAGEVIEW 75000
#define TAG_PUBLICLABEL   76000
#define TAG_lineYuanImage 77000
#define TAG_NetButton     78000

@interface SISettingViewController ()

@property (nonatomic, strong) NSString *currentTime;

@end

@implementation SISettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)goChangeTiming:(UIButton *)sender
{
    
    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:TAG_lineYuanImage];
    switch (sender.tag) {
        case 73001:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(20, 90 + 40, 30, 30);
            [UIView commitAnimations];
            self.currentTime = @"10";//add
            break;
        case 73002:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(20 + 59, 90 + 40, 30, 30);
            [UIView commitAnimations];
            self.currentTime = @"20"; //add
            break;
        case 73003:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(140, 90 + 40, 30, 30);
            [UIView commitAnimations];
            self.currentTime = @"30"; //add
            break;
        case 73004:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(140 + 63, 90 + 40, 30, 30);
            [UIView commitAnimations];
            self.currentTime = @"40"; //add
            break;
        case 73005:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(203 + 63, 90 + 40, 30, 30);
            [UIView commitAnimations];
            self.currentTime = @"50";//add
            break;
            
        default:
            break;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CHANGETIME" object:nil userInfo:@{@"totalTime":self.currentTime}];

}

- (void)goChangeBttonImage:(UIButton *)sender
{
    if (sender.tag == TAG_CLOSEBUTTON) {

        int flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TIMER"] intValue];
        
        if (flag == 0) {
            [sender setImage:[UIImage imageNamed:@"fy_set_close_time.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"TIMER"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STARTTIMER" object:nil userInfo:@{@"totalTime":self.currentTime}];

        }else{
            [sender setImage:[UIImage imageNamed:@"fy_set_start_time.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"TIMER"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPTIMER" object:nil userInfo:nil];
            
            //add label reset
            UILabel *temp = (UILabel *)[self.view viewWithTag:888888];
            temp.text = @" ";

        }
        
//        if (isStartTiming) {
//            isStartTiming = NO;
//        }else{
//            isStartTiming = YES;
//        }
        
        
        
        
    }else{
        int flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"3G"] intValue];
        if (flag == 0) {
            [sender setImage:[UIImage imageNamed:@"fy_set_close_time.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"3G"];
        }else{
            [sender setImage:[UIImage imageNamed:@"fy_set_start_time.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"3G"];



        }
    }
}

#pragma --mark  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000000000"]];
    }

}

- (void)goToNextViewController:(UIButton *)sender
{
    if (sender.tag == TAG_GONextbutton + 4) {
        
        SISettingInfoViewController * viewController = [[SISettingInfoViewController alloc] init];
        viewController.type = 74004;
        [self.navigationController pushViewController:viewController animated:YES];

        
    }else if (sender.tag == TAG_GONextbutton + 5){
        SISettingInfoViewController * viewController = [[SISettingInfoViewController alloc] init];
        viewController.type = 74005;
        [self.navigationController pushViewController:viewController animated:YES];
        
    }else if (sender.tag == TAG_GONextbutton + 6){
        UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"欢迎拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"400-0000-000" otherButtonTitles:nil];
        actionSheet.tag = 7001;
        [self.view addSubview:actionSheet];
        [actionSheet showInView:self.view];
    
    }
    

}

- (void)initImageView
{
    
    UIImageView * imageView3 = (UIImageView * )[self.view viewWithTag:TAG_LEFTIMAGEVIEW + 3];
    UILabel * label3 = (UILabel *)[self.view viewWithTag:TAG_PUBLICLABEL + 3];
    [imageView3 setImage:[UIImage imageNamed:@"fy_set_tiaokuan.png"]];
    imageView3.userInteractionEnabled = YES;
    label3.text = @"使用条款";
    label3.userInteractionEnabled = YES;
    
    UIImageView * imageView4 = (UIImageView * )[self.view viewWithTag:TAG_LEFTIMAGEVIEW + 4];
    UILabel * label4 = (UILabel *)[self.view viewWithTag:TAG_PUBLICLABEL + 4];
    [imageView4 setImage:[UIImage imageNamed:@"fy_set_about.png"]];
    imageView4.userInteractionEnabled = YES;
    label4.text = @"关于我们";
    label4.userInteractionEnabled = YES;
    
    UIImageView * imageView5 = (UIImageView * )[self.view viewWithTag:TAG_LEFTIMAGEVIEW + 5];
    UILabel * label5 = (UILabel *)[self.view viewWithTag:TAG_PUBLICLABEL + 5];
    [imageView5 setImage:[UIImage imageNamed:@"fy_set_telphone.png"]];
    imageView5.userInteractionEnabled = YES;
    label5.text = @"客服中心：400-0000-000";
    label5.userInteractionEnabled = YES;
    
}

- (void)initTableView
{
    TPKeyboardAvoidingScrollView *  bgView = [[TPKeyboardAvoidingScrollView alloc]initWithFrame:CGRectMake(0, 44 + StatusBarHeight, 320, self.view.frame.size.height -44 - StatusBarHeight)];
    bgView.contentSize = CGSizeMake(320, self.view.frame.size.height - 44 - StatusBarHeight + 10);
    bgView.tag = 8702;
    bgView.backgroundColor = [UIColor clearColor];
    bgView.userInteractionEnabled = YES;
    [bgView setScrollEnabled:YES];
    [bgView setShowsVerticalScrollIndicator:YES];
    [bgView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:bgView];
    
    UIView * contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor colorWithRed:226.0/255.0 green: 231.0/255.0 blue:249.0/255.0 alpha:1.0];
    contentView.userInteractionEnabled = YES;
    contentView.frame = CGRectMake(3, 5 , 314, 315);
    contentView.layer.cornerRadius = 6.0f;
    [bgView addSubview:contentView];
    
    //    ==============================================================================================
    float cellheightY = 0;
    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(3, cellheightY, 314, 45);
    button1.tag = TAG_BUTTON + 1;
    [button1 addTarget:self action:@selector(goToNextViewController:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button1];
    
    UIImageView * imageView1 = [[UIImageView alloc] init];
    imageView1.frame = CGRectMake(10, cellheightY + 5, 30, 30);
    [imageView1 setImage:[UIImage imageNamed:@"fy_set_wifi.png"]];
    imageView1.userInteractionEnabled = YES;
    [contentView addSubview:imageView1];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(60,0,235, 45)];
    label1.font = [UIFont systemFontOfSize:16];
    label1.text = @"2G/3G下收听";
    label1.backgroundColor = [UIColor clearColor];
    label1.userInteractionEnabled = YES;
    label1.textColor = [UIColor colorWithRed:21.0/255.0 green: 34.0/255.0 blue:100.0/255.0 alpha:1.0];
    [contentView addSubview:label1];
    
    /**
     *  add switch on network
     */
    
    UIButton * netButton = [[UIButton alloc] initWithFrame:CGRectMake(230, cellheightY + 15, 75, 24)];
    netButton.tag = TAG_NetButton;
    netButton.showsTouchWhenHighlighted = YES;
    
    //read flag
    int flag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"3G"] intValue];
    if (flag == 0) {
        [netButton setImage:[UIImage imageNamed:@"fy_set_start_time.png"] forState:UIControlStateNormal];
    }else{
        [netButton setImage:[UIImage imageNamed:@"fy_set_close_time.png"] forState:UIControlStateNormal];
    }
    [netButton addTarget:self action:@selector(goChangeBttonImage:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:netButton];
    
    
    
    UIImageView * lineView1 = [[UIImageView alloc]init];
    lineView1.frame = CGRectMake(0, cellheightY +44 ,314, 1);
    lineView1.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
    [contentView addSubview:lineView1];
    
    cellheightY += 45;
    // =========================================
    
    UIImageView * imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(10, cellheightY + 5, 30, 30);
    [imageView2 setImage:[UIImage imageNamed:@"fy_set_time.png"]];
    imageView2.userInteractionEnabled = YES;
    [contentView addSubview:imageView2];
    
    isStartTiming = NO;
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, cellheightY,235, 45)];
    label2.font = [UIFont systemFontOfSize:16];
    label2.text = @"定时关闭";
    label2.backgroundColor = [UIColor clearColor];
    label2.userInteractionEnabled = YES;
    label2.textColor = [UIColor colorWithRed:21.0/255.0 green: 34.0/255.0 blue:100.0/255.0 alpha:1.0];
    [contentView addSubview:label2];
    
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(100+50, cellheightY, 50, 45)];
    label3.font = [UIFont systemFontOfSize:14];
    //label3.text = @"60:69";
    label3.backgroundColor = CLEAR_COLOR;
    label3.textColor = RED_COLOR;
    label3.tag = 888888;
    [contentView addSubview:label3];
    
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(230, cellheightY + 15, 75, 24)];
    closeButton.tag = TAG_CLOSEBUTTON;
    closeButton.showsTouchWhenHighlighted = YES;
    
    
    /**
     *  修改，增加一个本地标志位
     */
    int T = [[[NSUserDefaults standardUserDefaults] objectForKey:@"TIMER"] intValue];
    
    if (T == 0) {
        [closeButton setImage:[UIImage imageNamed:@"fy_set_start_time.png"] forState:UIControlStateNormal];
 
    }else{
        [closeButton setImage:[UIImage imageNamed:@"fy_set_close_time.png"] forState:UIControlStateNormal];

    }
    [closeButton addTarget:self action:@selector(goChangeBttonImage:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:closeButton];

    UIImageView * lineView2 = [[UIImageView alloc]init];
    lineView2.frame = CGRectMake(0, cellheightY +44 ,314, 1);
    lineView2.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
    [contentView addSubview:lineView2];
    
    cellheightY += 45;
    // ================================
    
    for (int j = 0; j< 5; j ++) {
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(20 + 56 * j, cellheightY + 20, 56, 50)];
        button.tag = TAG_TIMINGBUTTON + j + 1;
        [button addTarget:self action:@selector(goChangeTiming:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + 60 * j, cellheightY + 15, 60, 30)];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.textColor = [UIColor colorWithRed:105.0/255.0 green:108.0/255.0 blue:112.0/255.0 alpha:1.0];
        timeLabel.userInteractionEnabled = YES;
        timeLabel.text = [NSString stringWithFormat:@"%d分钟",(j + 1)*10];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:timeLabel];
    
    }
    
    
    
    UIImageView * slidTimeImageView = [[UIImageView alloc] init];
    slidTimeImageView.frame = CGRectMake(20, cellheightY + 40, 280, 30);
    [slidTimeImageView setImage:[UIImage imageNamed:@"fy_set_line_tiao.png"]];
    [bgView addSubview:slidTimeImageView];
    
    UIImageView * lineYuanImageView = [[UIImageView alloc] init];
    lineYuanImageView.frame = CGRectMake(140, cellheightY + 40, 30, 30);
    [lineYuanImageView setImage:[UIImage imageNamed:@"fy_set_line_yuan.png"]];
    lineYuanImageView.tag = TAG_lineYuanImage;
    [bgView addSubview:lineYuanImageView];
    
    UIImageView * lineView3 = [[UIImageView alloc]init];
    lineView3.frame = CGRectMake(0, cellheightY + 87 ,314, 1);
    lineView3.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
    [contentView addSubview:lineView3];
    
    cellheightY += 90;
    
    // ===================================
    
    for (int k = 3; k < 6; k ++) {
        UIButton * goNextbutton = [[UIButton alloc] init];
        goNextbutton.frame = CGRectMake(3, cellheightY + 45 * (k - 3), 314, 45);
        goNextbutton.tag = TAG_GONextbutton + k + 1;
        [goNextbutton addTarget:self action:@selector(goToNextViewController:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:goNextbutton];
        
        UIImageView * leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, cellheightY + 5 + 45 * (k - 3), 30, 30)];
        leftImageView.tag = TAG_LEFTIMAGEVIEW + k;
        [contentView addSubview:leftImageView];
        
        UILabel * publicLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, cellheightY + 45 * (k - 3),235, 40)];
        publicLabel.font = [UIFont systemFontOfSize:16];
        publicLabel.backgroundColor = [UIColor clearColor];
        publicLabel.userInteractionEnabled = YES;
        publicLabel.textColor = [UIColor colorWithRed:21.0/255.0 green: 34.0/255.0 blue:100.0/255.0 alpha:1.0];
        publicLabel.tag = TAG_PUBLICLABEL + k;
        [contentView addSubview:publicLabel];
        
        if (k != 5) {
            UIImageView * lineView = [[UIImageView alloc]init];
            lineView.frame = CGRectMake(0, 44 ,314, 1);
            lineView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
            [goNextbutton addSubview:lineView];
        }
        
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [super showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:@"系统设置"];
    
    
    [self initTableView];
    [self initImageView];
    
    
    self.currentTime = @"30";
    
    // Do any additional setup after loading the view.
    
    //add notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeLabel:) name:@"CHANGECOUNT" object:nil];
    
    //add notification  if user in this vc and the countdown is running , if the count == 0 and change the swith on countdown
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSwitch) name:@"CHANGE_PLAYER_STATUS" object:nil];
}

//ADD CHANGEtIME LABEL
- (void)changeTimeLabel:(NSNotification *)noti
{
    int t = [noti.userInfo[@"COUNT"]intValue];
    
    NSString *str = [NSString stringWithFormat:@"%d:%d",t/60,t%60];
    
    
    UILabel *temp = (UILabel *)[self.view viewWithTag:888888];
    
    if (t==1) {
        temp.text = @" ";
        
    }else{
    
        temp.text = str;
    }
}

- (void)changeSwitch
{
    UIButton *temp = (UIButton *)[self.view viewWithTag:TAG_CLOSEBUTTON];
    [temp setImage:[UIImage imageNamed:@"fy_set_start_time.png"] forState:UIControlStateNormal];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (flag == 1) {
        [self showPlayer];
    }else{
        [[FMPlayer shareManager] changeFrame:Small_Frame];
        [[FMPlayer shareManager] removeFromSuperview];

    }
}

- (void)showPlayer
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[FMPlayer shareManager] changeFrame:Big_Frame];
    }else{
        [[FMPlayer shareManager] changeFrame:Big_FrameForiOS6];
    }
    
    [self.view addSubview:[FMPlayer shareManager]];
    
    
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
