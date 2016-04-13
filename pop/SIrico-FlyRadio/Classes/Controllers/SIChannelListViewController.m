//
//  SIChannelListViewController.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIChannelListViewController.h"
#import "EGOImageView.h"
#import "SIChannelInfoEntity.h"
#import "SIPlayViewController.h"
#import "SIAreaEntity.h"
#import "SIDBManger.h"
#import "MMLocationManager.h"
#import "SIricoUtils.h"
#import "MyAlertView.h"
#import "SICollectInfoDao.h"
#import "SICollectInfoEntity.h"
#import "SIShowInfoEntity.h"

@interface SIChannelListViewController ()

@property (nonatomic, strong) NSString *cidOrAid;
@property (nonatomic, assign) ChannelType channelType;
@property (nonatomic, strong) NSMutableArray *showArray;


@end

@implementation SIChannelListViewController


- (id)initWithTidOrAid:(NSString *)cid channelType:(ChannelType)type
{
    if (self = [super init]) {
        
        self.cidOrAid = [cid copy];
        self.channelType = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height - (44 + StatusBarHeight + 10)) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView setSeparatorColor:[UIColor clearColor]];
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    // init tipLabel
    tipLabel = [[UILabel alloc]init];
    tipLabel.text = @"暂无数据";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = [UIFont boldSystemFontOfSize:16];
    tipLabel.numberOfLines = 0;
    tipLabel.frame = CGRectMake(0, (myTableView.frame.size.height)/2, myTableView.frame.size.width, 30);
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.hidden = YES;
    [myTableView addSubview:tipLabel];
    
    dataArray = [[NSMutableArray alloc]init];
    collectDataArray = [[NSMutableArray alloc] init];
    _showArray = [NSMutableArray arrayWithCapacity:10];
    
    [self refreshData];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshData{
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:loadingView];
    
    [self getListData];
}


#pragma mark - get list data
- (void)getListData
{
    if (_channelType == ChannelType_AreaChannel) {
        //修改，根据地区id 请求网络来获取电台数据
        
        [self getChannleWithAreaID:_cidOrAid];
        
        
//        //TODO:  由地区进入的，根据地区ID查数据库。
//        //两种情况,全部数据，和地区数据
//        if (_cidOrAid.intValue == 1) {
//            //全部数据
//            dataArray = [[SIDBManger shareManger] getAllChannel];
//        }else{
//            //各地区数据
//            dataArray = [[SIDBManger shareManger]getChannelWithAreaID:_cidOrAid];
//        
//        }
//        
//        //reload data
//        [myTableView reloadData];
//        [loadingView stopLoadingAndDisappear];
        
    }else{
        // 这里分为 本地，收藏，top
        if (_channelType == ChannelType_Local) {
            
            //定位
            [[MMLocationManager shareLocation]getAddress:^(NSString *addressString) {
                NSString *areaID = [[SIDBManger shareManger] getAreaIdWithAreaName:addressString];
                dataArray = [[SIDBManger shareManger] getChannelWithAreaID:areaID];
                
                //reload data
                [myTableView reloadData];
                [loadingView stopLoadingAndDisappear];
                
            } error:^(NSError *error) {
                DBLog(@"定位失败~");
                [loadingView stopLoadingAndDisappear];
            }];
            
        }else if(_channelType == ChannelType_Top){
            
            [self getChannelTop];
            
            
        }else if(_channelType == ChannelType_Collection){
            
            
            [self getCollectionWithUserId];
            
//            dataArray = [[SIDBManger shareManger] getAllCollection];
//            
//            //reload data
//            [myTableView reloadData];
//            [loadingView stopLoadingAndDisappear];
        }else{
            //TODO:分类的列表
            dataArray = [[SIDBManger shareManger] getChannelWithFenLeiID:_cidOrAid];
            //reload data
            [myTableView reloadData];
            [loadingView stopLoadingAndDisappear];
        }
    
    }

    
    
}


#pragma mark - getChannelTop
- (void)getChannelTop
{
    
    [[HTTPManager shareManager] postPath:CHANNEL_TOP_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            //NSLog(@"jsonObj::::%@",jsonObj);
            for (NSDictionary *data in jsonObj) {
                //NSLog(@"data::::%@",data);
                
                //TODO: 其他情况，显示电台列表。
                SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc] initWithData:data];
                [dataArray addObject:item];
                item = nil;
                
            }
            
            
        }else{
            
        }
        //reload data
        [myTableView reloadData];
        [loadingView stopLoadingAndDisappear];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [loadingView stopLoadingAndDisappear];

    }];
    
}

- (void)getChannleWithAreaID:(NSString *)aid
{
    
    NSDictionary *parameter = @{@"Areaid":aid};

    [[HTTPManager shareManager] postPath:CHANNEL_FOR_AREA_URI parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            //NSLog(@"jsonObj::::%@",jsonObj);
            for (NSDictionary *data in jsonObj) {
                //NSLog(@"data::::%@",data);
                
                //TODO: 其他情况，显示电台列表。
                SIChannelInfoEntity *item = [[SIChannelInfoEntity alloc] initWithData:data];
                [dataArray addObject:item];
                item = nil;
                
            }
            
            
        }else{
            
        }
        //reload data
        [myTableView reloadData];
        [loadingView stopLoadingAndDisappear];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [loadingView stopLoadingAndDisappear];

    }];
    

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


- (void)getCollectionWithUserId
{
    NSDictionary * parameter = [NSDictionary dictionary];
    NSString * userId = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
    if (userId) {
          parameter = @{@"sbnumber":userId};
    }else{
        [[MyAlertView sharedMyAlertView] showWithName:@"请在首页登陆" afterDelay:0.5f];
        return;
    }
    
    [[HTTPManager shareManager] postPath:Get_SHOUCANG_URL parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            NSLog(@"jsonObj::::%@",jsonObj);
            for (NSDictionary *data in jsonObj) {
                SICollectInfoEntity *item = [[SICollectInfoEntity alloc] initWithData:data];
                [dataArray addObject:item];
                item = nil;
            }
            
            [self initCollectChannels:dataArray];
            if (dataArray.count == 0) {
                tipLabel.hidden = NO;
            }else{
                tipLabel.hidden = YES;
                [self reloadDataFromDB];
            }
            
        }
        
        [loadingView stopLoadingAndDisappear];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [loadingView stopLoadingAndDisappear];

    }];
    

}

- (void)reloadDataFromDB
{
    if(collectDataArray){
        [collectDataArray removeAllObjects];
    }
    SICollectInfoDao * dao = [[SICollectInfoDao alloc] init];
    collectDataArray = [dao findCollectChannels:[SIAppDelegate getDatabase]];
    [myTableView reloadData];
    
}






#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier=@"CellIdentifier";
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSUInteger row = [indexPath row];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
     	cell.backgroundColor = [UIColor clearColor];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * selectColorView = [[UIView alloc]init];
        [selectColorView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectedBackgroundView:selectColorView];
        
        UIImageView * bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"fy_play_statue_bg.png"];
        bgView.frame = CGRectMake(5, 0, 310, 48);
        bgView.backgroundColor = [UIColor clearColor];
        [cell.contentView  addSubview:bgView];
        

      
        UILabel * titleLabel1 = [[UILabel alloc]init];
        titleLabel1.frame = CGRectMake(10, 3, 195, 27);
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.textColor = [UIColor whiteColor];
        titleLabel1.font = [UIFont systemFontOfSize:15];
        titleLabel1.numberOfLines = 0;
        titleLabel1.tag = 10000;
        titleLabel1.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:titleLabel1];
        
        UILabel * titleLabel2 = [[UILabel alloc]init];
        titleLabel2.frame = CGRectMake(10, 30, 195,15);
        titleLabel2.backgroundColor = [UIColor clearColor];
        titleLabel2.textColor = [UIColor whiteColor];
        titleLabel2.font = [UIFont systemFontOfSize:13];
        titleLabel2.textAlignment = NSTextAlignmentLeft;
        titleLabel2.tag = 10001;
        [bgView addSubview:titleLabel2];
        
        UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(262, 0, 48, 48);
        [playButton setImage:[UIImage imageNamed:@"fy_channelplay_radio.png"] forState:UIControlStateNormal];
        playButton.tag = 10001 + indexPath.row;
        [playButton addTarget:self action:@selector(playRadioActon:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:playButton];
        
    
        
    }
    
    SIChannelInfoEntity * object = [dataArray objectAtIndex:row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
    nameLabel.text = object.channelName;
    
    UILabel *tipLabel = (UILabel *)[cell viewWithTag:10001];
    tipLabel.text = object.channelFm;
    


 	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SIPlayViewController *playercontroller = [[SIPlayViewController alloc] initWithData:dataArray index:indexPath.row];
//    playercontroller.isPlay = @"Yes";
//    [self.navigationController pushViewController:playercontroller animated:YES];
    NSString *channelID = [dataArray[indexPath.row] channelID];

    [self getShowInfoWithCID:channelID andIndex:indexPath.row];
    
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:loadingView];

    
    
}


- (void)playRadioActon:(UIButton *)sender
{
//    SIChannelInfoEntity * object = [dataArray objectAtIndex:sender.tag-10001];
    
//    SIPlayViewController *playercontroller = [[SIPlayViewController alloc] initWithData:dataArray index:indexPath.row];
//    [self.navigationController pushViewController:playercontroller animated:YES];

    
    //
    
    //TODO:分类讨论，地区则继续推向自己。 电台则推向播放器。
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"flag======%d",flag);
    if (flag ==1) {
        [self showPlayer];
    }else{
        [self hidePlayer];
    }
}


- (void)setNavigationTitle
{
    NSString *str = nil;
    if(_channelType == ChannelType_Collection)
    {
        str = @"收藏电台";
    }else if(_channelType == ChannelType_Economy){
        str = @"经济电台";
    }else if(_channelType == ChannelType_Foreign){
        str = @"国外地区列表";
    }else if(_channelType == ChannelType_Internal){
        str = @"国内地区列表";
    }else if(_channelType == ChannelType_Local){
        str = @"本地电台";
    }else if(_channelType == ChannelType_Music){
        str = @"音乐电台";
    }else if(_channelType == ChannelType_News){
        str = @"新闻电台";
    }else if(_channelType == ChannelType_Opera){
        str = @"曲艺电台";
    }else if(_channelType == ChannelType_Sports){
        str = @"体育电台";
    }else if(_channelType == ChannelType_Top){
        str = @"电台榜";
    }else if(_channelType == ChannelType_Transport){
        str = @"交通电台";
    }else if(_channelType == ChannelType_Travel){
        str = @"旅游电台";
    }else {
        NSString *strr = [[SIDBManger shareManger]getAreanameWithAreaID:_cidOrAid];
        str = [NSString stringWithFormat:@"%@地区",strr];
    }
    
    [super showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:str];

}



#pragma mark - show Player
- (void)showPlayer
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[FMPlayer shareManager] changeFrame:Big_Frame];
    }else{
        [[FMPlayer shareManager] changeFrame:Big_FrameForiOS6];
    }
    
    [self.view addSubview:[FMPlayer shareManager]];
    
    myTableView.frame = CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height- (44 + StatusBarHeight + 10) - 70);
}


#pragma mark - get show Info
- (void)getShowInfoWithCID:(NSString *)channelID andIndex:(NSInteger)index
{
    if (_showArray.count != 0) {
        [_showArray removeAllObjects];
    }
    
   // NSString *cid = [_listData[_currentIndex] channelID];

    NSDictionary *parameter = @{@"channelid":channelID};
    
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
        
        [loadingView stopLoadingAndDisappear];
        
        //作比较，提示用户是否有节目。
        
        
        if ([self hasShowTime]) {
            
            SIPlayViewController *playercontroller = [[SIPlayViewController alloc] initWithData:dataArray index:index];
            playercontroller.isPlay = @"Yes";
            [self.navigationController pushViewController:playercontroller animated:YES];

            
        }else{
             [[MyAlertView sharedMyAlertView] showWithName:@"当前时段无节目" afterDelay:0.8f];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBError(error);
        [loadingView stopLoadingAndDisappear];

        
    }];
    
}

- (BOOL)hasShowTime
{
    NSString * nowTime = [[NSDate date] stringWithFormate:@"YYYY/MM/dd HH:mm:ss"];
    int hour = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] firstObject] intValue];
    int min = [[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] [1] intValue];
//    int sec = [[[[[nowTime componentsSeparatedByString:@" "] lastObject] componentsSeparatedByString:@":"] lastObject] intValue];
    
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
            return YES;
        }
    }
    return NO;
}



- (void)hidePlayer
{
    [[FMPlayer shareManager] changeFrame:Small_Frame];
    
    //[self.view addSubview:[FMPlayer shareManager]];
    [[FMPlayer shareManager] removeFromSuperview];
    
    myTableView.frame = CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height - (44 + StatusBarHeight + 10));

}

@end
