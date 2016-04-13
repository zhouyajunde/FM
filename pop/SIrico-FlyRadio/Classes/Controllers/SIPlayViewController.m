//
//  SIPlayViewController.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIPlayViewController.h"
#import "SIChannelInfoEntity.h"
#include "SIAdEntity.h"
#import "SICollectInfoEntity.h"
#import "SICollectInfoDao.h"
#import "EWPickerView.h"
#import "SIricoUtils.h"
#import "MyAlertView.h"
#import "SIShowInfoEntity.h"
#import "SILoginViewController.h"


#define TAG_COLLECTTABLEVIEW  98700
#define TAG_COMMENTTABLEVIEW  98701
#define TAG_COMMENTBUTTON     98800
#define TAG_COMMENTLABEL      98900
#define TAG_COMMENTIMAGE      98703
#define TAG_LEFTBUTTON        64500
#define TAG_RIGHTBUTTON       64505
#define TAG_PLAYBUTTON        68000

@interface SIPlayViewController ()<EWCycleViewDataSource,EWCycleViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *listData;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) EWPickerView *pickView;
@property (nonatomic, strong) EWCycleView *cycleView;
@property (nonatomic, strong) NSMutableArray *adData;
@property (nonatomic, strong) UILabel *tiemLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *zcLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSString * currentChannelId;
@property (nonatomic, assign) BOOL isUpdateUI;

@property (nonatomic, strong) NSMutableArray *showArray;

- (void)configView;
- (void)initData;
- (void)getAdData;


@end

@implementation SIPlayViewController
@synthesize isPlay;

- (instancetype)initWithData:(NSMutableArray *)data index:(NSInteger)index
{
    if (self = [super init]) {
        _listData = [data mutableCopy];
        _currentIndex = index;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopLoading:) name:KFMplayerStatusUpdata object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canNotPlay:) name:@"cannotplay" object:nil];
    }
    return self;
}


- (void)dealloc
{
    DBLog(@"xxxxxxx------xxxxxxxx");
}

- (void)playRadio
{
     NSString * userDafultChannelId = [SIricoUtils getStringFromUserDefaults:kSettingOfCurrentChannelId];
     NSString * currentChannelId = [[_listData objectAtIndex:_currentIndex] channelID];
    if (userDafultChannelId && currentChannelId && ![userDafultChannelId isEqualToString:currentChannelId]) {
        flag = 0;
    }
    //播放或更换频道前，先检测是否有上次的收听记录需要提交
    [self checkIscommitListenRecord];
    if (flag == 0) {
        
        [self loadChannel];
        
        DBLog(@"first in ---------");
        
    }
    else{
        
        DBLog(@"second in ----------");
        
        //对比，如果当前的不是
        
        if ([[[FMPlayer shareManager]currentUrl] isEqualToString:[_listData[_currentIndex] channelURL]]) {
            
            [[FMPlayer shareManager] startPlay];
            
            //定时器刷新
            [self startTimer];
            
            //告诉播放器
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startUpdata" object:nil];

        }else{
        
            //重新选台
            [self loadChannel];
        }
        
    }
    
    UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
    tempBtn.selected = YES;
    
}


- (void)loadChannel
{
    [self resetTimer];
    [[FMPlayer shareManager] setPlayURL:[[_listData objectAtIndex:_currentIndex] channelURL ]];
    [[FMPlayer shareManager] setListData:_listData index:_currentIndex];
    
    flag = 1;
    //sent notification
    //        NSLog(@"flag111111111111====%d",flag);
    [self loadingView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *string = [NSString stringWithFormat:@"%@ %@",[[_listData objectAtIndex:_currentIndex] channelFm],[[_listData objectAtIndex:_currentIndex] channelName]];
     [super showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:string];

	// Do any additional setup after loading the view.
    DBLog(@"终于学会了，还有什么问题呢？");
    //[self setTitleandTime];
    
    [self configView];
    [self initData];
    if (isNetConnected) {
        [self getAdData];
        [self getShowInfo];
    }else{
        DBLog(@"没有网络!");
    }

//    //如果有开始时间记录则提交
//    if ([SIricoUtils getStringFromUserDefaults:kSettingOfListenStartTime]) {
//        NSString *endTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
//        [SIricoUtils storeStringInUserDefaults:kSettingOfListenEndTime string:endTime];
//        [self commitListenRecord];
//    }

    [self playRadio];
    
    shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    shadeView.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:12.0/255.0 blue:12.0/255.0 alpha:0.8f];
    shadeView.hidden = YES;
    [self.view addSubview:shadeView];
    
    UITapGestureRecognizer * tapGestureRecognizer = [[UITapGestureRecognizer alloc]init];
    [tapGestureRecognizer addTarget:self action:@selector(touchAction:)];
    [shadeView addGestureRecognizer:tapGestureRecognizer];
    
    collectTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT - 250)/2, SCREEN_WIDTH - 20, 250)];
    collectTableView.layer.cornerRadius = 6.0f;
    collectTableView.tag = TAG_COLLECTTABLEVIEW;
    collectTableView.delegate = self;
    collectTableView.dataSource = self;
    collectTableView.hidden = YES;
    collectTableView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green: 229.0/255.0 blue:230.0/255.0 alpha:1.0];
    [collectTableView setSeparatorColor:[UIColor clearColor]];
    collectTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectTableView];
    
    // init tipLabel
    tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"暂无数据";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.numberOfLines = 0;
    tipLabel.frame = CGRectMake(0, (collectTableView.frame.size.height)/2, collectTableView.frame.size.width, 30);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.hidden = YES;
    [collectTableView addSubview:tipLabel];
  

    
    commentTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, (SCREEN_HEIGHT - 400)/2, SCREEN_WIDTH - 20, 400)];
    commentTableView.layer.cornerRadius = 6.0f;
    commentTableView.tag = TAG_COMMENTTABLEVIEW;
    commentTableView.delegate = self;
    commentTableView.dataSource = self;
    commentTableView.hidden = YES;
    commentTableView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green: 229.0/255.0 blue:230.0/255.0 alpha:1.0];
    [commentTableView setSeparatorColor:[UIColor clearColor]];
    commentTableView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:commentTableView];
    
    collectDataArray = [[NSMutableArray alloc] init];
    allDataArray = [[NSMutableArray alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    if ([self.isPlay isEqualToString:@"Yes"]) {
    //        [[FMPlayer shareManager] stopPlay];
    //        [[FMPlayer shareManager] changeFrame:CGRectZero];
    //        self.isPlay = @"No";
    //        flag = 1;
    //    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_cycleView stopAutoRun];
    [self resetTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)configView
{
    [self change];
    
    _cycleView = [[EWCycleView alloc] initWithFrame:CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, 150) showPageIndicator:YES];
    if (self.view.frame.size.height < 500) {
        _cycleView.frame = CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, 140);
    }
    //DBLog(@"+++++frame=%@",NSStringFromCGRect(_cycleView.frame));
    _cycleView.dataSource = self;
    _cycleView.delegate = self;
    _cycleView.timeInterval = 5;
    [self.view addSubview:_cycleView];
    
    float heightY = _cycleView.frame.origin.y + _cycleView.frame.size.height;
    
    UIView *controlBack = [[UIView alloc] initWithFrame:CGRectMake(0, heightY, SCREEN_WIDTH, 170)];
    controlBack.backgroundColor = RGB_COLOR(231, 237, 233);
    [self.view addSubview:controlBack];
    if (self.view.frame.size.height < 500) {
        controlBack.frame = CGRectMake(0, 194+StatusBarHeight, SCREEN_WIDTH, 140);
    }
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 105, 40)];
    _nameLabel.text = @"汽车音乐风";
    _nameLabel.textColor = RGB_COLOR(149, 191, 89);
    _nameLabel.backgroundColor = CLEAR_COLOR;
    
    _nameLabel.font = [UIFont systemFontOfSize:20];
    [controlBack addSubview:_nameLabel];
    
    
    _zcLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 55, 105, 20)];
    _zcLabel.text = @"";
    _zcLabel.backgroundColor = CLEAR_COLOR;
    _zcLabel.font = [UIFont systemFontOfSize:12];
    [controlBack addSubview:_zcLabel];
    
    
    _tiemLabel = [[UILabel alloc] initWithFrame:CGRectMake(17, 75, 105, 20)];
    _tiemLabel.text = @"00:00:00";
    _tiemLabel.backgroundColor = CLEAR_COLOR;
    _tiemLabel.font = [UIFont systemFontOfSize:12];
    [controlBack addSubview:_tiemLabel];
    
    UIButton *preBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    preBtn.frame = CGRectMake(130, 24, 46, 52);
    //preBtn.backgroundColor = GRAY_COLOR;
    [preBtn addTarget:self action:@selector(pre:) forControlEvents:UIControlEventTouchUpInside];
    [preBtn setBackgroundImage:[UIImage imageNamed:@"fy_pre"] forState:UIControlStateNormal];
    [controlBack addSubview:preBtn];
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playBtn.frame = CGRectMake(176, 10, 80, 80);
    playBtn.selected = YES;
    playBtn.tag = TAG_PLAYBUTTON;
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    //playBtn.backgroundColor = GRAY_COLOR;
    [playBtn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
    [controlBack addSubview:playBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(256, 24, 46, 52);
    //nextBtn.backgroundColor = GRAY_COLOR;
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"fy_next"] forState:UIControlStateNormal];
    [controlBack addSubview:nextBtn];
    
    
    UIButton *collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectBtn.frame = CGRectMake(43.5, 120, 96.5, 32);
    [collectBtn setBackgroundImage:[UIImage imageNamed:@"fy_shoucang"] forState:UIControlStateNormal];
    [collectBtn addTarget:self action:@selector(goCollectAction) forControlEvents:UIControlEventTouchUpInside];
    [controlBack addSubview:collectBtn];
    
    UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    commentBtn.frame = CGRectMake(180, 120, 96.5, 32);
    [commentBtn setBackgroundImage:[UIImage imageNamed:@"fy_pfen"] forState:UIControlStateNormal];
    [commentBtn addTarget:self action:@selector(goCommentAction) forControlEvents:UIControlEventTouchUpInside];
    [controlBack addSubview:commentBtn];
    
    if (self.view.frame.size.height < 500) {
        collectBtn.frame = CGRectMake(43.5, 95, 96.5, 32);
        commentBtn.frame = CGRectMake(180, 95, 96.5, 32);
    }
    
    heightY += controlBack.frame.size.height;
    
    UIImageView * bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, heightY, 320, self.view.frame.size.height - heightY)];
    bgImageView.userInteractionEnabled = YES;
    [bgImageView setImage:[UIImage imageNamed:@"fy_bg_gunlun.png"]];
    [self.view addSubview:bgImageView];
    
    _pickView = [[EWPickerView alloc] initWithFrame:CGRectMake(0, 0, 320,bgImageView.bounds.size.height)];
    _pickView.backgroundColor = [UIColor clearColor];
    _pickView.delegate = self;
    _pickView.dataSource = self;
    
    [_pickView selectRow:_currentIndex inComponent:0 animated:YES];
    [bgImageView addSubview:_pickView];
    
}

- (void)initData
{
    _adData = [NSMutableArray arrayWithCapacity:10];
    _showArray = [NSMutableArray arrayWithCapacity:10];
    
    _isUpdateUI = NO;
    
    commentDataArray1 = [[NSMutableArray alloc] initWithObjects:@"",@"节目形式多样",@"贴近生活",@"信息及时",@"娱乐性强",@"最潮流", nil];
    commentDataArray2 = [[NSMutableArray alloc] initWithObjects:@"",@"节目内容丰富",@"轻松活波",@"放松心情",@"丰富知识",@"最权威", nil];
    
}

#pragma mark - get jm and zc pingfen 

- (void)getZcPingFen
{
    // 获取节目评价内容
    
    [[HTTPManager shareManager] postPath:GET_ZCPINGJIA_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (commentDataArray1) {
            [commentDataArray1 removeAllObjects];
            [commentDataArray1 addObject:@""];
        }
        if (commentDataArray2) {
            [commentDataArray2 removeAllObjects];
            [commentDataArray2 addObject:@""];
        }
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"jsonObj:::%@",jsonObj);
        
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *data in jsonObj) {
                [tempArray addObject:[data objectForKey:@"zcpj"]];
            }
            for (int i = 0; i < tempArray.count; i ++ ) {
                if (i < 5) {
                    [commentDataArray1 addObject:[tempArray objectAtIndex:i]];
                }else{
                    [commentDataArray2 addObject:[tempArray objectAtIndex:i]];
                }
            }
        }
        shadeView.hidden = NO;
        commentTableView.hidden = NO;
        [commentTableView reloadData];
        tableViewHeadTitle = @"主持人评价";

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
    }];
    
}

- (void) getJmPingFen
{
    // 获取节目评价内容
    
    [[HTTPManager shareManager] postPath:GET_JMPINGJIA_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if (commentDataArray1) {
            [commentDataArray1 removeAllObjects];
            [commentDataArray1 addObject:@""];
        }
        if (commentDataArray2) {
            [commentDataArray2 removeAllObjects];
            [commentDataArray2 addObject:@""];
        }
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            NSMutableArray * tempArray = [[NSMutableArray alloc] init];
            for (NSDictionary *data in jsonObj) {
                [tempArray addObject:[data objectForKey:@"jmpj"]];
            }
            for (int i = 0; i < tempArray.count; i ++ ) {
                if (i < 5) {
                    [commentDataArray1 addObject:[tempArray objectAtIndex:i]];
                }else{
                    [commentDataArray2 addObject:[tempArray objectAtIndex:i]];
                }
            }
        }
        shadeView.hidden = NO;
        commentTableView.hidden = NO;
        [commentTableView reloadData];
        tableViewHeadTitle = @"节目评价";

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];
    

}

- (void)commitAddPingJia
{

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    NSString * currentSbnumber = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
    if (currentSbnumber) {
        [parameters setObject:currentSbnumber forKey:@"sbnumber"];
    }else{
        [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfTempUserDeviceId] forKey:@"sbnumber"];
//        [parameters setObject:@"tmp" forKey:@"sbnumber"];
    }
    [parameters setObject:[[_listData objectAtIndex:_currentIndex] channelID] forKey:@"channelid"];
    
    if (_nameLabel.text) {
         [parameters setObject:_nameLabel.text forKey:@"jmdname"];
    }else{
        [parameters setObject:@"暂无节目" forKey:@"jmdname"];
    }
    if (_zcLabel.text){
        [parameters setObject:_zcLabel.text forKey:@"zc"];
    }else{
         [parameters setObject:@"无" forKey:@"zc"];
    }
    
    //节目评分和评价
    NSString * JmPingFen = [SIricoUtils getStringFromUserDefaults:kSettingOfJmPingFen];
    if (JmPingFen) {
        [parameters setObject:JmPingFen forKey:@"jmf"];
    }else{
        [parameters setObject:[NSString stringWithFormat:@"%d",3] forKey:@"jmf"];
    }
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfJmPingJia] forKey:@"jmpj"];
    
    //主持人评分和评价
    NSString * ZcPingFen = [SIricoUtils getStringFromUserDefaults:kSettingOfZcPingFen];
    NSLog(@"ZcPingFen::::%@",ZcPingFen);
    if (ZcPingFen) {
        [parameters setObject:ZcPingFen forKey:@"zcf"];
    }else{
        [parameters setObject:[NSString stringWithFormat:@"%d",3] forKey:@"zcf"];
    }
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfZcPingJia] forKey:@"zcpj"];
    
    [SIricoUtils removeStringFromUserDefaults:kSettingOfJmPingFen];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfJmPingJia];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfZcPingFen];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfZcPingJia];
    

    [[HTTPManager shareManager] postPath:ADD_PINGJIA_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        commentTableView.hidden = YES;
        shadeView.hidden = YES;
        [[MyAlertView sharedMyAlertView] showWithName:@"评价提交成功" afterDelay:0.5f];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        commentTableView.hidden = YES;
        shadeView.hidden = YES;
        [[MyAlertView sharedMyAlertView] showWithName:@"评价提交失败" afterDelay:0.5f];

        
    }];

}

#pragma mark - Action

- (void)goCommentAction
{
    [self getJmPingFen];
}


- (void)goCollectAction
{
    if ([SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId]) {
        addOrcancel = @"Add";
        [self refreshData];
    }else{
        [[MyAlertView sharedMyAlertView] showWithName:@"请在首页登陆" afterDelay:0.5f];
        SILoginViewController * viewController = [[SILoginViewController alloc] init];
        [self.navigationController pushViewController:viewController animated:YES];
    }
    
}

- (void)touchAction:(UITapGestureRecognizer *)sender
{
    shadeView.hidden = YES;
    collectTableView.hidden = YES;
    commentTableView.hidden = YES;
    
}

- (void) refreshData{
//    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(10, (SCREEN_HEIGHT - 250)/2, SCREEN_WIDTH - 20, 250)];
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
    [self.view addSubview:loadingView];
    
    if ([addOrcancel isEqualToString:@"Add"]) {
        //Test
//        [self getCollectListData];
        //添加收藏频道
           [self AddCollectChannel];
    }else{
        [self cancelCollectChannel];
    
    }

}

- (void)initCollectChannels:(NSMutableArray *)collectList
{
    FMDatabase *database = [SIAppDelegate getDatabase];
    //从服务端可以取到商场信息，这时，更新数据库
    if(collectList != nil){
        SICollectInfoDao *dao =[[SICollectInfoDao alloc] init];
        [database beginTransaction];
        for(SICollectInfoEntity *object in collectList){
            //第一步删重复的历史数据
            [dao setDatabase:database deleteByChannelId:object.channelID];
            [dao setDatabase:database saveCollect:object];
        }
        [database commit];
    }
}

#pragma mark - commitListenRecord

- (void)checkIscommitListenRecord
{
    NSString * userDafultChannelId = [SIricoUtils getStringFromUserDefaults:kSettingOfCurrentChannelId];
    NSString * currentChannelId = [[_listData objectAtIndex:_currentIndex] channelID];
    if (userDafultChannelId) {
        //判断是否更换频道，如果更换则提交
        if (![currentChannelId isEqualToString:userDafultChannelId]) {
            //如果有开始时间记录 则记录结束时间
            if ([SIricoUtils getStringFromUserDefaults:kSettingOfListenStartTime]) {
                NSString *endTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
                
                NSLog(@"endTime:::%@",endTime);
                [SIricoUtils storeStringInUserDefaults:kSettingOfListenEndTime string:endTime];
                [self commitListenRecord];
            }
        }
       
    }
     //如果是第一次播放，储存当前频道Id和开始时间
    else{
        [SIricoUtils storeStringInUserDefaults:kSettingOfCurrentChannelId string:currentChannelId];
        NSString *startTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
        [SIricoUtils storeStringInUserDefaults:kSettingOfListenStartTime string:startTime];
    }
}
- (void)commitListenRecord
{

    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    
    //获取要提交得channelid
    NSString * channelid = [SIricoUtils getStringFromUserDefaults:kSettingOfCurrentChannelId];
    if (channelid) {
         [parameters setObject:channelid forKey:@"channelid"];
    }
    [parameters setObject:[[_listData objectAtIndex:_currentIndex] channelFm] forKey:@"channelname"];
    NSString * starttime = [SIricoUtils getStringFromUserDefaults:kSettingOfListenStartTime];
    NSLog(@"888888888:::%@",starttime);
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfListenStartTime] forKey:@"starttime"];
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfListenEndTime] forKey:@"endtime"];
    
    NSString * currentSbnumber = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
    if (currentSbnumber) {
        [parameters setObject:currentSbnumber forKey:@"sbnumber"];
    }else{
       [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfTempUserDeviceId] forKey:@"sbnumber"];
    }
    
    //删除历史 时间记录
    [SIricoUtils removeStringFromUserDefaults:kSettingOfListenStartTime];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfListenEndTime];
//    [SIricoUtils removeStringFromUserDefaults:kSettingOfCurrentChannelId];
    
    [[HTTPManager shareManager] postPath:LISTEN_RECOR_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [[MyAlertView sharedMyAlertView] showWithName:@"记录保存成功" afterDelay:1.0f];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
//        [[MyAlertView sharedMyAlertView] showWithName:@"记录保存失败" afterDelay:1.0f];
    }];
    
    //提交完上次收听记录以后，储存当前channelid和开始时间
    [SIricoUtils storeStringInUserDefaults:kSettingOfCurrentChannelId string:[[_listData objectAtIndex:_currentIndex] channelID]];
    NSString *startTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
    [SIricoUtils storeStringInUserDefaults:kSettingOfListenStartTime string:startTime];

}

- (void)AddCollectChannel
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    NSString * userId = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
    if (userId) {
        [parameters setObject:userId forKey:@"sbnumber"];
        [parameters setObject:[[_listData objectAtIndex:_currentIndex] channelID] forKey:@"channelid"];
        
        [[HTTPManager shareManager] postPath:Add_SHOUCANG_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSError *error = nil;
            
            NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:&error];
            NSString * message = [[dic objectForKey:@"string"] objectForKey:@"text"];
//            NSLog(@"text111111111111%@",[[dic objectForKey:@"string"] objectForKey:@"text"]);
            if ([message isEqualToString:@"该频道已经收藏"]) {
                [loadingView stopLoadingAndDisappear];
                [[MyAlertView sharedMyAlertView] showWithName:@"该频道已经收藏" afterDelay:1.0f];
            }else{
                //收藏成功，获取收藏list
                shadeView.hidden = NO;
                collectTableView.hidden = NO;
                [self getCollectListData];
                [[MyAlertView sharedMyAlertView] showWithName:@"收藏成功" afterDelay:1.0f];
            }
           
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            DBError(error);
            [loadingView stopLoadingAndDisappear];
            [[MyAlertView sharedMyAlertView] showWithName:@"收藏失败" afterDelay:1.0f];
            
        }];
    }else{
        [loadingView stopLoadingAndDisappear];
        shadeView.hidden = YES;
        collectTableView.hidden = YES;
    }

}


- (void) getCollectListData
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    NSString * userId = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
    if (userId) {
            [parameters setObject:userId forKey:@"sbnumber"];
    }else{
        [[MyAlertView sharedMyAlertView] showWithName:@"请在首页登陆" afterDelay:1.0];
        return;
    }
    
    [[HTTPManager shareManager] postPath:Get_SHOUCANG_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            if (allDataArray) {
                [allDataArray removeAllObjects];
            }
            
            for (NSDictionary *data in jsonObj) {
                SICollectInfoEntity *item = [[SICollectInfoEntity alloc] initWithData:data];
                [allDataArray addObject:item];
                item = nil;
            }
            
            [self initCollectChannels:allDataArray];
            
            if (allDataArray.count == 0) {
                tipLabel.hidden = NO;
            }else{
                tipLabel.hidden = YES;
                [self reloadDataFromDB];
            }
           
        }else{
            
        }
        [loadingView stopLoadingAndDisappear];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [self reloadDataFromDB];
        [loadingView stopLoadingAndDisappear];

    }];
    
}

- (void)cancelCollectChannel
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId] forKey:@"sbnumber"];
    [parameters setObject:[SIricoUtils getStringFromUserDefaults:kSettingOfCancelChannelId] forKey:@"channelid"];
    //删除记录
    [SIricoUtils removeStringFromUserDefaults:kSettingOfCancelChannelId];
    
    
    [[HTTPManager shareManager] postPath:Del_SHOUCANG_URL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
//        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:&error];
        
        NSLog(@"dic====%@",dic);
        
        NSLog(@"text====%@",[[dic objectForKey:@"string"] objectForKey:@"text"]);
        
        //收藏成功，获取收藏list
        [self getCollectListData];
        //        [loadingView stopLoadingAndDisappear];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [loadingView stopLoadingAndDisappear];
        //        [[MyAlertView sharedMyAlertView] showWithName:@"失败" afterDelay:1.0f];

    }];
    
}

- (void)cancelCllectActon:(UIButton *)sender
{
    
    [SIricoUtils storeStringInUserDefaults:kSettingOfCancelChannelId string:[[collectDataArray objectAtIndex:sender.tag - 10001] channelID]];
    
    [self refreshData];
}

- (void)getAdData
{
    
    [[HTTPManager shareManager] postPath:AID_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                SIAdEntity *item = [[SIAdEntity alloc] initWithData:data];
                DBLog(@"iamge=%@",item.adImg);
                [_adData addObject:item];
                item = nil;
            }
            [_cycleView reloadData];
            [_cycleView startAutoRun];
            
        }else{
            
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];
    
    [[HTTPManager shareManager] postPath:AID_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}


#pragma mark - get SHow info
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
//                DBLog(@"show name=%@",item.showName);
//                DBLog(@"show time=%@",item.startTime);
//                DBLog(@"show endtime=%@",item.endTime);
                [_showArray addObject:item];
                item = nil;
            }
            
        }else{
            
            
        }

       // [self setTitleandTime];
        _isUpdateUI = YES;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];
    
}


- (void)reloadDataFromDB
{
    if(collectDataArray){
        [collectDataArray removeAllObjects];
    }
    SICollectInfoDao * dao = [[SICollectInfoDao alloc] init];
    collectDataArray = [dao findCollectChannels:[SIAppDelegate getDatabase]];
    [collectTableView reloadData];
    
}


#pragma mark - cycle datasource
- (NSInteger)numberOfPages:(EWCycleView *)cycleView
{
    return [_adData count];
}

- (UIView *)cycleView:(EWCycleView *)cycleView pageAtIndex:(NSInteger)index
{
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    NSString *path = [NSString stringWithFormat:@"%@%@",BASE_URL,[_adData[index] adImg]];
    [imageView setImageWithURL:[NSURL URLWithString:path ]placeholderImage:nil];
    return imageView;
}

- (NSString *)cycleView:(EWCycleView *)cycleView titleForPageAtIndex:(NSInteger)index
{
    return [[_adData objectAtIndex:index] adName];
    
}

#pragma mark - cycle delegate
- (void)cycleView:(EWCycleView *)cycleView didSelectAtIndex:(NSInteger)index
{
    
}

#pragma mark - uipickview delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [_listData count];
}

- (float)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 59.0f;
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 59)];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 29.5)];
    lab1.textAlignment = NSTextAlignmentCenter;
    //lab1.font = [UIFont systemFontOfSize:20];
    lab1.font = [UIFont boldSystemFontOfSize:20];
    lab1.textColor = WHITE_COLOR;
    lab1.backgroundColor = CLEAR_COLOR;
    [backView addSubview:lab1];
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 29.5, 320, 29.5)];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.backgroundColor = CLEAR_COLOR;
    lab2.font = [UIFont systemFontOfSize:15];
    lab2.textColor = WHITE_COLOR;
    [backView addSubview:lab2];
    
    lab1.text = [_listData[row] channelName];
    lab2.text = [_listData[row] channelFm];
    
    return backView;
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _currentIndex = row;
    [self change];
//    flag = 0;
//    [self playRadio];
    [[FMPlayer shareManager] stopPlay];
    [self resetTimer];
    flag = 0;
    //选中 一起更新 ui
    _isUpdateUI = NO;
    [self getNewShowInfo];

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
        _isUpdateUI = YES;
        
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
            [self playRadio];
            
            UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
            [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
            tempBtn.selected = YES;
            
            
        }else{
            [[MyAlertView sharedMyAlertView] showWithName:@"当期时段无节目" afterDelay:0.5f];
            
            UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
            [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_play.png"] forState:UIControlStateNormal];
            tempBtn.selected = NO;

            
            DBLog(@"没有节目哦!");
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        
    }];

}


#pragma mark -  UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TAG_COLLECTTABLEVIEW) {
        return collectDataArray.count;
    }else{
        return 6;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag == TAG_COLLECTTABLEVIEW) {
        return 50;
    }else{
        if (indexPath.row == 0) {
            return 90;
        }else{
            return 45;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier= [NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSUInteger row = [indexPath row];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
     	cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * selectColorView = [[UIView alloc]init];
        [selectColorView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectedBackgroundView:selectColorView];
        
        if (tableView.tag == TAG_COLLECTTABLEVIEW) {
            UIImageView * bgView = [[UIImageView alloc]init];
            bgView.image = [UIImage imageNamed:@"fy_play_statue_bg.png"];
            bgView.frame = CGRectMake(5,3, 290, 45);
            bgView.userInteractionEnabled = YES;
            bgView.backgroundColor = [UIColor clearColor];
            [cell.contentView  addSubview:bgView];
            
            UILabel * titleLabel1 = [[UILabel alloc]init];
            titleLabel1.frame = CGRectMake(10, 3, 195, 27);
            titleLabel1.backgroundColor = [UIColor clearColor];
            titleLabel1.textColor = [UIColor colorWithRed:223.0/255.0 green: 223.0/255.0 blue:223.0/255.0 alpha:1.0];
            titleLabel1.font = [UIFont systemFontOfSize:15];
            titleLabel1.numberOfLines = 0;
            titleLabel1.tag = 10000;
            titleLabel1.textAlignment = NSTextAlignmentLeft;
            [bgView addSubview:titleLabel1];
            
            UILabel * titleLabel2 = [[UILabel alloc]init];
            titleLabel2.frame = CGRectMake(10, 30, 195,15);
            titleLabel2.backgroundColor = [UIColor clearColor];
            titleLabel2.textColor = [UIColor colorWithRed:223.0/255.0 green: 223.0/255.0 blue:223.0/255.0 alpha:1.0];
            titleLabel2.font = [UIFont systemFontOfSize:13];
            titleLabel2.textAlignment = NSTextAlignmentLeft;
            titleLabel2.tag = 10001;
            [bgView addSubview:titleLabel2];
            
            UIButton * cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            cancelButton.frame = CGRectMake(245, 0, 45, 45);
            [cancelButton setImage:[UIImage imageNamed:@"cang_cancel.png"] forState:UIControlStateNormal];
            cancelButton.tag = 10001 + indexPath.row;
            [cancelButton addTarget:self action:@selector(cancelCllectActon:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:cancelButton];
        }
        else{
            
            if (row == 0) {
                for (int j = 0; j< 5; j ++) {
                    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(10 + 56 * j, 0, 56, 90)];
                    button.tag = TAG_COMMENTBUTTON + j + 1;
                    [button addTarget:self action:@selector(goChangeCommentScore:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:button];
                }
                
                UIImageView * slidTimeImageView = [[UIImageView alloc] init];
                slidTimeImageView.frame = CGRectMake(10,19, 280, 52);
                [slidTimeImageView setImage:[UIImage imageNamed:@"fy_pj_toutiao.png"]];
                [cell.contentView addSubview:slidTimeImageView];
                
                UIImageView * lineYuanImageView = [[UIImageView alloc] init];
                lineYuanImageView.frame = CGRectMake(134,16, 30, 30);
                [lineYuanImageView setImage:[UIImage imageNamed:@"fy_huakuai_toutiao.png"]];
                lineYuanImageView.tag = TAG_COMMENTIMAGE;
                [cell.contentView addSubview:lineYuanImageView];
                
                for (int k = 0; k< 5; k ++) {
                    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10 + 56 * k, 0, 56, 60)];
                    NSString * labelString = [NSString stringWithFormat:@"%d分",5-k];
                    label.text = labelString;
                    label.tag = TAG_COMMENTLABEL + k + 1;
                    label.font = [UIFont systemFontOfSize:12];
                    label.textColor = [UIColor colorWithRed:140.0/255.0 green: 140.0/255.0 blue:140.0/255.0 alpha:1.0];
                    label.textAlignment = NSTextAlignmentCenter;
                    label.backgroundColor = [UIColor clearColor];
                    [cell.contentView addSubview:label];
                }
                
                
                UIImageView * lineView3 = [[UIImageView alloc]init];
                lineView3.frame = CGRectMake(0, 89 ,300, 1);
                lineView3.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
                [cell.contentView addSubview:lineView3];
                
            }
            else{
                UILabel * titleLabel1 = [[UILabel alloc]init];
                titleLabel1.frame = CGRectMake(15, 0,90,35);
                titleLabel1.backgroundColor = [UIColor clearColor];
                titleLabel1.textColor = [UIColor colorWithRed:140.0/255.0 green: 140.0/255.0 blue:140.0/255.0 alpha:1.0];
                titleLabel1.tag = 87601;
                titleLabel1.font = [UIFont systemFontOfSize:14];
                titleLabel1.numberOfLines = 0;
                titleLabel1.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:titleLabel1];
                
                UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(105,8, 35, 19)];
                button.tag = 45600 + indexPath.row;
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                button.tag = TAG_LEFTBUTTON + indexPath.row;
                [button addTarget:self action:@selector(goSelectComment:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                UILabel * titleLabel2 = [[UILabel alloc]init];
                titleLabel2.frame = CGRectMake(155, 0,85,35);
                titleLabel2.backgroundColor = [UIColor clearColor];
                titleLabel2.textColor = [UIColor colorWithRed:140.0/255.0 green: 140.0/255.0 blue:140.0/255.0 alpha:1.0];
                titleLabel2.tag = 87602;
                titleLabel2.font = [UIFont systemFontOfSize:14];
                titleLabel2.textAlignment = NSTextAlignmentLeft;
                [cell.contentView addSubview:titleLabel2];
                
                UIButton * button1 = [[UIButton alloc] initWithFrame:CGRectMake(250, 8,35, 19)];
                button1.tag = 45670 + indexPath.row;
                [button1 setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                button1.tag = TAG_RIGHTBUTTON + indexPath.row;
                [button1 addTarget:self action:@selector(goSelectComment:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button1];
                
                if (row == 5) {
                    UIImageView * lineView3 = [[UIImageView alloc]init];
                    lineView3.frame = CGRectMake(0, 44 ,300, 1);
                    lineView3.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
                    [cell.contentView addSubview:lineView3];
                }
                
            }
            
        }
        
    }
    
    if (tableView.tag == TAG_COLLECTTABLEVIEW) {
        SIChannelInfoEntity * object = [collectDataArray objectAtIndex:row];
        
        UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
        nameLabel.text = object.channelName;
        
        UILabel *tipLabel = (UILabel *)[cell viewWithTag:10001];
        tipLabel.text = object.channelFm;
    }
    else if (tableView.tag == TAG_COMMENTTABLEVIEW){
        
        UILabel *leftLabel = (UILabel *)[cell.contentView viewWithTag:87601];
        leftLabel.text = [commentDataArray1 objectAtIndex:indexPath.row];
        
        UILabel *rightLabel = (UILabel *)[cell.contentView viewWithTag:87602];
        rightLabel.text = [commentDataArray2 objectAtIndex:indexPath.row];
    }
    return cell;
}


- (void)goChangeCommentScore:(UIButton *)sender
{
    if ([tableViewHeadTitle isEqualToString:@"节目评价"]) {
        NSString * jmPingfen = [NSString stringWithFormat:@"%d",6 - (sender.tag - TAG_COMMENTBUTTON)];
        [SIricoUtils storeStringInUserDefaults:kSettingOfJmPingFen string:jmPingfen];
    }else{
    
        NSString * zcPingfen = [NSString stringWithFormat:@"%d",6 - (sender.tag - TAG_COMMENTBUTTON)];
        [SIricoUtils storeStringInUserDefaults:kSettingOfZcPingFen string:zcPingfen];
    }
   
    for (int i = 1; i< 6; i++) {
        UILabel * label = (UILabel *)[self.view viewWithTag:TAG_COMMENTLABEL + i];
        
        if (label.tag == (sender.tag + 100)) {
            label.font = [UIFont boldSystemFontOfSize:16];
            label.textColor = [UIColor whiteColor];
        }
        else{
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor colorWithRed:140.0/255.0 green: 140.0/255.0 blue:140.0/255.0 alpha:1.0];
            
        }
    }
    
    UIImageView * imageView = (UIImageView *)[self.view viewWithTag:TAG_COMMENTIMAGE];
    switch (sender.tag) {
        case 98801:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(20, 16, 30, 30);
            [UIView commitAnimations];
            break;
        case 98802:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(20 + 59, 16, 30, 30);
            [UIView commitAnimations];
            break;
        case 98803:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(134,16, 30, 30);
            [UIView commitAnimations];
            break;
        case 98804:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(134 + 55, 16, 30, 30);
            [UIView commitAnimations];
            break;
        case 98805:
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.3];
            imageView.frame = CGRectMake(190 + 55,16, 30, 30);
            [UIView commitAnimations];
            break;
            
        default:
            break;
    }
    
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == TAG_COLLECTTABLEVIEW) {
        return 50;
    }else{
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectio
{
    if (tableView.tag == TAG_COMMENTTABLEVIEW) {
        return 70;
    }else{
        return 0;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView* myView = [[UIView alloc] init];
    myView.layer.masksToBounds = YES;
    myView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green: 229.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    UIImageView * duiImageView = [[UIImageView alloc]init];
    duiImageView.frame = CGRectMake(5, 7 ,45, 41);
    duiImageView.backgroundColor = [UIColor clearColor];
    [duiImageView setImage:[UIImage imageNamed:@"fy_shoucang_dg.png"]];
    [myView addSubview:duiImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 220, 50)];
    titleLabel.textColor=[UIColor colorWithRed:140.0/255.0 green: 140.0/255.0 blue:140.0/255.0 alpha:1.0];
    titleLabel.text = @"已收藏";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    
    UIImageView * lineView1 = [[UIImageView alloc]init];
    lineView1.frame = CGRectMake(0, 49 ,300, 1);
    lineView1.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
    [myView addSubview:lineView1];
    
    if (tableView.tag == TAG_COMMENTTABLEVIEW) {
        duiImageView.frame = CGRectMake(5, 0 ,30, 30);
        titleLabel.frame = CGRectMake(50, 0, 230, 30);
        titleLabel.text = tableViewHeadTitle;
        titleLabel.font = [UIFont systemFontOfSize:14];
        lineView1.frame = CGRectMake(0, 29 ,300, 1);
    }
    
    return myView;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView* myView = [[UIView alloc] init];
    myView.layer.masksToBounds = YES;
    myView.backgroundColor = [UIColor colorWithRed:225.0/255.0 green: 229.0/255.0 blue:230.0/255.0 alpha:1.0];
    
    UIImageView * lineView3 = [[UIImageView alloc]init];
    lineView3.frame = CGRectMake(0, 8 ,300, 1);
    lineView3.backgroundColor = [UIColor colorWithRed:203.0/255.0 green: 209.0/255.0 blue:219.0/255.0 alpha:1.0];
    [myView addSubview:lineView3];
    
    UIButton * commitButton = [[UIButton alloc] initWithFrame:CGRectMake(90,19,40, 40)];
    [commitButton setImage:[UIImage imageNamed:@"fy_duigou.png"] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(goCommitAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:commitButton];
    
    UIButton * closeButton = [[UIButton alloc] initWithFrame:CGRectMake(170, 19,40, 40)];
    [closeButton setImage:[UIImage imageNamed:@"fy_cuohao.png"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(goCloseAction:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:closeButton];
    
    return myView;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelect999");
}


#pragma mark - commintAction

- (void)goSelectComment:(UIButton *)sender
{
    UIButton * button = (UIButton *)[self.view viewWithTag:sender.tag];
    
    if ([tableViewHeadTitle isEqualToString:@"节目评价"]){
        if (sender.tag < 64506) {
            [SIricoUtils storeStringInUserDefaults:kSettingOfJmPingJia string:[commentDataArray1 objectAtIndex:sender.tag - 64500]];
        }else{
            [SIricoUtils storeStringInUserDefaults:kSettingOfJmPingJia string:[commentDataArray2 objectAtIndex:sender.tag - 64505]];
        }
    }else{
        if (sender.tag < 64506) {
            [SIricoUtils storeStringInUserDefaults:kSettingOfZcPingJia string:[commentDataArray1 objectAtIndex:sender.tag - 64500]];
        }else{
            [SIricoUtils storeStringInUserDefaults:kSettingOfZcPingJia string:[commentDataArray2 objectAtIndex:sender.tag - 64505]];
        }

    
    }
    
    switch (button.tag) {
        case 64501:
            if (isKaiCommit10) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit10 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                
                isKaiCommit10 = YES;
            }
            
            break;
        case 64506:
            if (isKaiCommit11) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit11 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit11 = YES;
            }
            break;
        case 64502:
            if (isKaiCommit20) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit20 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit20 = YES;
            }
            
            break;
        case 64507:
            if (isKaiCommit21) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit21 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit21 = YES;
            }
            break;
            
        case 64503:
            if (isKaiCommit30) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit30 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit30 = YES;
            }
            
            break;
        case 64508:
            if (isKaiCommit31) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit31 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit31 = YES;
            }
            break;
            
        case 64504:
            if (isKaiCommit40) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit40 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit40 = YES;
            }
            
            break;
        case 64509:
            if (isKaiCommit41) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit41 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit41 = YES;
            }
            break;
        case 64505:
            if (isKaiCommit50) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit50 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit50 = YES;
            }
            
            break;
        case 64510:
            if (isKaiCommit51) {
                [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
                isKaiCommit51 = NO;
            }else{
                [button setImage:[UIImage imageNamed:@"fy_ping_kai.png"] forState:UIControlStateNormal];
                isKaiCommit51 = YES;
            }
            break;
            
            
        default:
            break;
    }
    
    for (int i =  64501; i < 64511; i ++ ) {
        UIButton * button = (UIButton *)[self.view viewWithTag:i];
        if (button.tag != sender.tag) {
            [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)goCommitAction:(UIButton *)sender
{
    NSLog(@"11111111111111=%@",[SIricoUtils getStringFromUserDefaults:kSettingOfJmPingJia]);
    NSLog(@"22222222222222=%@",[SIricoUtils getStringFromUserDefaults:kSettingOfZcPingJia]);
    NSLog(@"33333333333333=%@",[SIricoUtils getStringFromUserDefaults:kSettingOfZcPingFen]);
    NSLog(@"44444444444444=%@",[SIricoUtils getStringFromUserDefaults:kSettingOfJmPingFen]);
    if ([SIricoUtils getStringFromUserDefaults:kSettingOfJmPingJia]&& [SIricoUtils getStringFromUserDefaults:kSettingOfZcPingJia]) {
         [self commitAddPingJia];
        
    }else if([SIricoUtils getStringFromUserDefaults:kSettingOfJmPingJia] ){
        //获取主持人评分内容
        [self getZcPingFen];
        
        for (int i =  64501; i < 64511; i ++ ) {
            UIButton * button = (UIButton *)[self.view viewWithTag:i];
            [button setImage:[UIImage imageNamed:@"fy_p_guan.png"] forState:UIControlStateNormal];
        }
    }
    
}

- (void)goCloseAction:(UIButton *)sender
{
    [SIricoUtils removeStringFromUserDefaults:kSettingOfJmPingFen];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfJmPingJia];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfZcPingFen];
    [SIricoUtils removeStringFromUserDefaults:kSettingOfZcPingJia];
    shadeView.hidden = YES;
    collectTableView.hidden = YES;
    commentTableView.hidden = YES;
}


#pragma mark - play control
- (void)play:(UIButton *)btn
{
    if (btn.selected == NO) {
        if (flag == 0) {
            //NSLog(@"fmname=%@",[[_listData objectAtIndex:_currentIndex] channelURL ]);
            [self resetTimer];
            [[FMPlayer shareManager] setPlayURL:[[_listData objectAtIndex:_currentIndex] channelURL ]];
            [[FMPlayer shareManager] setListData:_listData index:_currentIndex];
            
            flag = 1;
            //sent notification
            //loading view
        
            [self loadingView];
            
            //更改标志位
            _isUpdateUI = NO;
            [self getShowInfo];

            
        }else{
        
            [[FMPlayer shareManager] startPlay];
            
            //暂停结束重新记录 开始时间
            NSString *startTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
            [SIricoUtils storeStringInUserDefaults:kSettingOfListenStartTime string:startTime];
            
            //开始播放 则 更新ui
            _isUpdateUI = YES;
        }
        [btn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
        
        btn.selected = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STARTFM" object:nil];

    }else{
        
        [[FMPlayer shareManager] pausePlay];
        
        //暂停 提交收听记录
         NSString *endTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
        [SIricoUtils storeStringInUserDefaults:kSettingOfListenEndTime string:endTime];
        [self commitListenRecord];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"fy_play.png"] forState:UIControlStateNormal];
        
        btn.selected = NO;
        
        //暂停了，要禁止更新UI
        _isUpdateUI = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPFM" object:nil];
    }
    
    
}

- (void)next:(UIButton *)btn
{
    
    if (_currentIndex < (_listData.count-1)) {
        [self resetTimer];
        
        [[FMPlayer shareManager] stopPlay];
        _currentIndex += 1;
        
        flag = 0;
        [self getNewShowInfo];
        
        

        //[[FMPlayer shareManager] setPlayURL:[[_listData objectAtIndex:_currentIndex] channelURL ]];
        //_tiemLabel.text = @"00:00:00";
        
        //flag = 1;
        //loading view
        //[self loadingView];
        
//        NSString *endTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd hh:mm:ss"];
//        NSLog(@"endTime::%@",endTime);
//        
//        [SIricoUtils storeStringInUserDefaults:kSettingOfListenEndTime string:endTime];
        
        [_pickView selectRow:_currentIndex inComponent:0 animated:YES];
        
        [self change];
//        [self commitListenRecord];
        //更换频道前，先检测是否有上次的收听记录需要提交
//        [self checkIscommitListenRecord];
        
//        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
//        [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
//        tempBtn.selected = YES;
//        
//        
//        //更改标志位
//        _isUpdateUI = NO;
//        [self getShowInfo];

    }
    
    
    
}

- (void)pre:(UIButton *)btn
{
    
    if (_currentIndex > 0) {
        [self resetTimer];
        
        [[FMPlayer shareManager] stopPlay];
        
        _currentIndex -= 1;
        
        [self getNewShowInfo];
        
        flag = 0;
        [_pickView selectRow:_currentIndex inComponent:0 animated:YES];

        
        //[[FMPlayer shareManager] setPlayURL:[[_listData objectAtIndex:_currentIndex] channelURL ]];
        //_tiemLabel.text = @"00:00:00";
        
        //flag = 1;
        //loading view
        //[self loadingView];
        
        [self change];
//        [self commitListenRecord];
        //更换频道前，先检测是否有上次的收听记录需要提交
//        [self checkIscommitListenRecord];
        
//        UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
//        [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_pause.png"] forState:UIControlStateNormal];
//        tempBtn.selected = YES;
//        
//        
//        //更改标志位
//        _isUpdateUI = NO;
//       [self getShowInfo];

    }
    
    
}

//load view
- (void)loadingView
{
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, StatusBarHeight + 44, 320, self.view.bounds.size.height -StatusBarHeight)];
    [self.view addSubview:loadingView];
    
}

//notification
- (void)stopLoading:(NSNotification *)noti
{
    FMplayerStatusCode code = [noti.userInfo[@"status"] intValue];
    
    if (code == FMplayerStatus_StartPlaying || code == FMplayerStatus_ErrorPlaying) {
        [loadingView stopLoadingAndDisappear];
        [self startTimer];
    }
}

//change title
- (void)change
{
    //NSString *string = [NSString stringWithFormat:@"%@ %@",[[_listData objectAtIndex:_currentIndex] channelFm],[[_listData objectAtIndex:_currentIndex] channelName]];
    
    _nameLabel.text = @"汽车音乐风";
    _zcLabel.text = @"";
    _tiemLabel.text = @"00:00:00";
//    [self resetTopMenuTitle:@""];
    
//    if (_currentIndex >0 || _currentIndex < _listData.count) {
//        [_pickView selectRow:_currentIndex inComponent:0 animated:YES];
//        
//    }
    
}

- (void)updateUI
{
    
    if (_isUpdateUI) {
        //增加体验。
        if (_showArray.count != 0) {
            [self setTitleandTime];

        }else{
            _nameLabel.text = @"汽车音乐风";
            _zcLabel.text = @"未知";
            _tiemLabel.text = @"00:00:00";
            
        }
    }
    
}


- (void)resetTimer
{
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    
    //_tiemLabel.text = @"";
    
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
}



#pragma mark - set now time and title
- (void)setTitleandTime
{
    
    NSString * nowTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd HH:mm:ss"];
    int hour = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] firstObject] intValue];
    int min = [[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] [1] intValue];
    int sec = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] lastObject] intValue];

    DBLog(@"now time =======%d",hour);
    float temp = [[NSString stringWithFormat:@"%d.%d",hour,min] floatValue];
    
    
    
    for (int i = 0; i < _showArray.count; i++) {
        int stime = [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] firstObject] intValue];
        int sMtime =  [[[[_showArray[i] startTime] componentsSeparatedByString:@":"] lastObject] intValue];
        
        float tempStart = [[NSString stringWithFormat:@"%d.%d",stime,sMtime] floatValue];
        
        int etime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] firstObject] intValue];
        int eMtime = [[[[_showArray[i] endTime] componentsSeparatedByString:@":"] lastObject] intValue];

        float tempEnd = [[NSString stringWithFormat:@"%d.%d",etime,eMtime] floatValue];

        
        
        if (temp >=tempStart && temp <= tempEnd) {
            DBLog(@"start time====%d",stime);
            DBLog(@"end time======%d",etime);
            
            //成立 取出:
            _nameLabel.text = [_showArray[i] showName];
            _zcLabel.text = [_showArray[i] showZC];
            
            //倒计时时间
            int lastHour = (etime*3600+eMtime*60-hour*3600-min*60-sec)/3600;
            int lastMin = (etime*3600+eMtime*60-hour*3600-min*60-sec)%3600/60;
            int lastSec = (etime*3600+eMtime*60-hour*3600-min*60-sec)%3600%60;
            _tiemLabel.text = [NSString stringWithFormat:@"%d:%d:%d",lastHour,lastMin,lastSec];
            
            [self resetTopMenuTitle:[NSString stringWithFormat:@"%@ %@",[_showArray[i] showName],[_showArray[i] showZC]]];
        }
    }
    
    
    
    NSLog(@"hello  this is  siplayviewcontroller ~~~");
    
}

#pragma mark - can not play
- (void)canNotPlay:(NSNotification *)noti
{
    //dddd
    DBLog(@"不能播放哦 亲");
    
    [loadingView stopLoadingAndDisappear];
    [[FMPlayer shareManager] stopPlay];
    flag = 0;
    
    [[MyAlertView sharedMyAlertView] showWithName:@"频道错误" afterDelay:0.5f];
    
    UIButton *tempBtn = (UIButton *)[self.view viewWithTag:TAG_PLAYBUTTON];
    [tempBtn setBackgroundImage:[UIImage imageNamed:@"fy_play.png"] forState:UIControlStateNormal];
    tempBtn.selected = NO;

    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
