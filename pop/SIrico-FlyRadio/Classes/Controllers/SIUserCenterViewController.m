//
//  SIUserCenterViewController.m
//  SIrico-FlyRadio
//
//  Created by fantasee on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIUserCenterViewController.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "SILoginViewController.h"
#import "SIInitDataViewController.h"
#import "SIChannelListViewController.h"
#import "SIricoUtils.h"
#import "SIUserInfoViewController.h"
#import "SIDHViewController.h"

#define TAG_BUTTON    56000
#define TAG_IMAGEVIEW 57000
#define TAG_LABEL     58000

@interface SIUserCenterViewController ()

- (void)p_requestJF:(NSString *)uid;

@end

@implementation SIUserCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma --mark
#pragma --mark  UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        if (actionSheet.tag == 7000) {
            SILoginViewController * viewController = [[SILoginViewController alloc] init];
            [self.navigationController pushViewController:viewController animated:YES];
            [SIricoUtils removeStringFromUserDefaults:kSettingOfUserDeviceId];
        }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4000000000"]];
        }
   
    }
    
}



- (void)goToNextViewController:(UIButton *)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出当前账号" otherButtonTitles:nil];
    actionSheet.tag = 7000;
    [self.view addSubview:actionSheet];
    
    UIActionSheet * actionSheet1 = [[UIActionSheet alloc]initWithTitle:@"欢迎拨打客服电话" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"400-0000-000" otherButtonTitles:nil];
    actionSheet1.tag = 7001;
    [self.view addSubview:actionSheet1];

    switch (sender.tag) {
        case 56001:
            //用户信息
        {
            DBLog(@"如果账户存在则去用户信息页面～");
            DBLog(@"测试，直接进入用户信息页面");
            SIUserInfoViewController *controller = [SIUserInfoViewController new];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            /*
            if ([SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId]) {
                SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:@"20"channelType:ChannelType_Collection];
                [self.navigationController pushViewController:listController animated:YES];
            }else{
                SILoginViewController * viewController = [[SILoginViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }*/
            break;
        case 56002:
            
            //我的收藏
            if ([SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId]) {
                SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:@"20"channelType:ChannelType_Collection];
                [self.navigationController pushViewController:listController animated:YES];
            }else{
                SILoginViewController * viewController = [[SILoginViewController alloc] init];
                [self.navigationController pushViewController:viewController animated:YES];
            }
            
//            if ([SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId]) {
//               SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:@"20"channelType:ChannelType_Collection];
//                [self.navigationController pushViewController:listController animated:YES];
//            }else{
//                SILoginViewController * viewController = [[SILoginViewController alloc] init];
//                [self.navigationController pushViewController:viewController animated:YES];
//            }

            break;
        case 56003:
            NSLog(@"------几分兑换");
        {
            SIDHViewController *controller = [[SIDHViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
        case 56004:
            NSLog(@"56004---客服中心");
            [actionSheet1 showInView:self.view];
            break;
        case 56005:
            break;
        case 56006:
            //[actionSheet1 showInView:self.view];
            break;
        case 56007:
            [actionSheet showInView:self.view];
            break;
            
        default:
            break;
    }
}

- (void)initImageAndTitle
{
    UIImageView * imageView1 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 1];
    UIImageView * imageView2 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 2];  //
    //UIImageView * imageView3 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 3];
    UIImageView * imageView4 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 3];
    //UIImageView * imageView5 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 5];
    UIImageView * imageView6 = (UIImageView *)[self.view viewWithTag:TAG_IMAGEVIEW + 4];  //修改原来是6
    UILabel * label1 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 1];
    UILabel * label2 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 2];
    //UILabel * label3 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 3];
    UILabel * label4 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 3];
    //UILabel * label5 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 5];
    UILabel * label6 = (UILabel *)[self.view viewWithTag:TAG_LABEL + 4];
    
    [imageView1 setImage:[UIImage imageNamed:@"user_info.png"]];
    [imageView2 setImage:[UIImage imageNamed:@"user_shoucang.png"]];
    //[imageView3 setImage:[UIImage imageNamed:@"user_jifen.png"]];
    [imageView4 setImage:[UIImage imageNamed:@"user_duihuan.png"]];
    //[imageView5 setImage:[UIImage imageNamed:@"user_fenxiang.png"]];
    [imageView6 setImage:[UIImage imageNamed:@"user_kefu.png"]];
    
    label1.text = @"用户信息";
    label2.text = @"我的收藏";
    //label3.text = @"我的积分";
    label4.text = @"积分兑换";
    //label5.text = @"好友分享";
    label6.text = @"客服中心：400-0000-000";

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
    contentView.frame = CGRectMake(3, 5, 314, 180); //修改，原来是270
    contentView.layer.cornerRadius = 6.0f;
    [bgView addSubview:contentView];
    //=========================================================================================
    for (int i = 0; i < 4; i ++) {
        UIButton * button = [[UIButton alloc] init];
        button.frame = CGRectMake(3, 5 + 45 * i, 314, 45);
        button.tag = TAG_BUTTON + i + 1;
        [button addTarget:self action:@selector(goToNextViewController:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 6 + 45 * i, 30, 30)];
        imageView.tag = TAG_IMAGEVIEW + i + 1;
        imageView.userInteractionEnabled = YES;
        [contentView addSubview:imageView];
        
        UILabel * label = [[UILabel alloc] init];
        label.frame = CGRectMake(60,45 * i, 235, 45);
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = [UIColor clearColor];
        label.tag = TAG_LABEL + i +1;
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor colorWithRed:21.0/255.0 green: 34.0/255.0 blue:100.0/255.0 alpha:1.0];
        [contentView addSubview:label];
        
        if (i != 5) {
            UIImageView * lineView = [[UIImageView alloc]init];
            lineView.frame = CGRectMake(0, 44 , 314, 1);
            lineView.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
            [button addSubview:lineView];
        }
        
        /**
         增加积分现实label
         */
        if (i == 2 ) {
            UILabel *jifen = [[UILabel alloc] initWithFrame:CGRectMake(314-100, 0, 100, 45)];
            jifen.backgroundColor = CLEAR_COLOR;
            jifen.font = [UIFont systemFontOfSize:14];
            jifen.textColor = GRAY_COLOR;
            //jifen.text = @"几分：123";
            jifen.tag = 99887766;
            [button addSubview:jifen];
        }
    }
    
    UIView * contentView1 = [[UIView alloc]init];
    contentView1.backgroundColor = [UIColor colorWithRed:226.0/255.0 green: 231.0/255.0 blue:249.0/255.0 alpha:1.0];
    contentView1.userInteractionEnabled = YES;
    contentView1.frame = CGRectMake(3, 10 + 180, 314, 45); //修改 原来是10+270
    contentView1.layer.cornerRadius = 6.0f;
    [bgView addSubview:contentView1];
    
    UIButton * button1 = [[UIButton alloc] init];
    button1.frame = CGRectMake(20, 25 + 180 , 280, 44);//修改 原来是25+270
    button1.tag = TAG_BUTTON + 7;
    [button1 addTarget:self action:@selector(goToNextViewController:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:button1];
    
    UIImageView * imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 30, 30)];
    [imageView1 setImage:[UIImage imageNamed:@"user_exit.png"]];
    [contentView1 addSubview:imageView1];
    
    UILabel * label1 = [[UILabel alloc] init];
    label1.frame = CGRectMake(60,0, 235, 40);
    label1.text = @"退出登录";
    label1.font = [UIFont systemFontOfSize:16];
    label1.backgroundColor = [UIColor clearColor];
    label1.userInteractionEnabled = YES;
    label1.textColor = [UIColor colorWithRed:21.0/255.0 green: 34.0/255.0 blue:100.0/255.0 alpha:1.0];
    [contentView1 addSubview:label1];
    
    UIImageView * exitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(275, 5, 30, 30)];
    [exitImageView setImage:[UIImage imageNamed:@"user_exit_out.png"]];
    [contentView1 addSubview:exitImageView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:@"用户中心"];
    
    [self initTableView];
    [self initImageAndTitle];
	// Do any additional setup after loading the view.
}

- (void)p_requestJF:(NSString *)uid
{
    [[HTTPManager shareManager] getPath:GET_ALLJF_URL parameters:@{@"jifen":@"0",@"sbnumber":@"APP23000018"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
       // DBLog(@"jsonobj=%@",jsonObj);

        UILabel *temp = (UILabel *)[self.view viewWithTag:99887766];
        temp.text = [NSString stringWithFormat:@"积分:%@",jsonObj];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self p_requestJF:@""];

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
    
    //_collection.frame = CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-70-5);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
