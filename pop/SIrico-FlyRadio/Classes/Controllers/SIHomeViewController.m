//
//  SIHomeViewController.m
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIHomeViewController.h"
#import "SIHomeCell.h"
#import "SIClassifyEntity.h"
#import "SIAdEntity.h"
#import "SIChannelListViewController.h"
#import "SIAreaListViewController.h"
#import "SIricoUtils.h"
#import "MyAlertView.h"
#import "SILoginViewController.h"



@interface SIHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,EWCycleViewDataSource,EWCycleViewDelegate>

@property (nonatomic, strong) EWCycleView *cycleView;
@property (nonatomic, strong) UICollectionView *collection;
@property (nonatomic, strong) NSMutableArray *adData;
@property (nonatomic, strong) NSMutableArray *listData;

- (void)initData;
- (void)getAdData;
- (void)getListData;
- (void)configView;
@end

@implementation SIHomeViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initData];
    [self configView];
    [self refreshData];
    
//    SILoginViewController * viewController = [[SILoginViewController alloc] init];
//    [self.navigationController pushViewController:viewController animated:YES];
//   
    

//    SILoginViewController * viewController = [[SILoginViewController alloc] init];
////    [super.navigationController pushViewController:viewController animated:YES];
//    [self presentViewController:viewController animated:YES completion:^{
//
//        }];
    
	// Do any additional setup after loading the view.
}

#pragma mark - initData
- (void)initData
{
    _adData = [NSMutableArray arrayWithCapacity:10];
    _listData = [NSMutableArray arrayWithCapacity:10];
}

- (void) refreshData{
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:loadingView];
    
    //[self getAdDataAndListData];
    
    if (isNetConnected) {
        
        [self getAdData];
       // [self getListData];
        
    }else{
        DBLog(@"没有网络~");
    }
}

#pragma mark - get Data
- (void)getAdData{
    
    if (_adData) {
        [_adData removeAllObjects];
    }
//    [[SIFRDotNetManager shareManager] request:AID_LIST_URI parameter:nil delete:self tag:10];
//    [[SIFRDotNetManager shareManager] request:CLASS_LIST_URI parameter:nil delete:self tag:20];
    
    [[HTTPManager shareManager] postPath:AID_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                SIAdEntity *item = [[SIAdEntity alloc] initWithData:data];
                //DBLog(@"iamge=%@",item.adImg);
                [_adData addObject:item];
                item = nil;
            }
            
            [self getListData];
            
        }else{
            
            
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DBError(error);
    }];
    

    
}

#pragma mark - get list data
- (void)getListData
{
    [[HTTPManager shareManager] postPath:CLASS_LIST_URI parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *data in jsonObj) {
                SIClassifyEntity *item = [[SIClassifyEntity alloc] initWithData:data];
                [_listData addObject:item];
                DBLog(@"----name=%@",item.className);
                DBLog(@"----id=%@",item.classID);
                item = nil;
            }
            
        }else{
            
            
        }
        //reload data
        [_cycleView reloadData];
        [_cycleView startAutoRun];
        [_collection reloadData];
        [loadingView stopLoadingAndDisappear];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DBError(error)
    }];
    
    
}



#pragma mark - config view
- (void)configView
{

    [super showTopMenuWithStyle:kTopMenuStyleGoSet withTitle:@""];
    
    UIImageView * topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(110, StatusBarHeight + 8, 100, 28)];
    [topImageView setImage:[UIImage imageNamed:@"fy_hone_toptitle_wenzi.png"]];
    [self.view addSubview:topImageView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.minimumLineSpacing = 2;
    layout.itemSize = CGSizeMake(104, 97.5);
    layout.sectionInset = UIEdgeInsetsMake(5, 2, 2, 2);
    

    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    if ([SystemVersion intValue] >= 7.0) {
        _collection.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    _collection.backgroundColor = [UIColor whiteColor];
    [_collection registerClass:[SIHomeCell class] forCellWithReuseIdentifier:@"cell"];
    _collection.delegate = self;
    _collection.dataSource = self;
    _collection.backgroundColor = CLEAR_COLOR;
    _collection.contentInset = UIEdgeInsetsMake(180, 0, 0, 0);
    _collection.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collection];

    _cycleView = [[EWCycleView alloc] initWithFrame:CGRectMake(0, -180, SCREEN_WIDTH, 180) showPageIndicator:YES];
    _cycleView.dataSource = self;
    _cycleView.delegate = self;
    _cycleView.timeInterval = 5;
    [_collection addSubview:_cycleView];

}

#pragma mark - collectionview data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.listData count];
}

- (SIHomeCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SIHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell setHomeCell:[_listData objectAtIndex:indexPath.row]];
    
    
	// Do any additional setup after loading the view.

    return cell;
}

#pragma mark - collection delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cid = [_listData[indexPath.row] classID];
    ChannelType type = [self getChannelType:cid.intValue];
    DBLog(@"type=====%d====cid==%@",type,cid);
    
    if (type == ChannelType_Internal || type == ChannelType_Foreign) {
        SIAreaListViewController *areaController = [[SIAreaListViewController alloc]initWithChannelType:type];
        [self.navigationController pushViewController:areaController animated:YES];
        
    }else if (type == ChannelType_Collection){
        
        NSString * userId = [SIricoUtils getStringFromUserDefaults:kSettingOfUserDeviceId];
        if (userId) {
            SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:cid channelType:type];
            [self.navigationController pushViewController:listController animated:YES];
        }else{

            SILoginViewController * viewController = [[SILoginViewController alloc] init];

            [self.navigationController pushViewController:viewController animated:YES];

        }
    
    }
    else{
    
        SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:cid channelType:type];
        [self.navigationController pushViewController:listController animated:YES];
    }
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


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (flag == 1) {
        [self showPlayer];
    }else{
    
        [[FMPlayer shareManager] changeFrame:Small_Frame];
        [[FMPlayer shareManager] removeFromSuperview];
        
        //[self.view addSubview:[FMPlayer shareManager]];
        
        _collection.frame = CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-5);

    }
}



#pragma mark - show player
- (void)showPlayer
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
     [[FMPlayer shareManager] changeFrame:Big_Frame];
    }else{
        [[FMPlayer shareManager] changeFrame:Big_FrameForiOS6];
    }
    
    [self.view addSubview:[FMPlayer shareManager]];
    
    _collection.frame = CGRectMake(0, 44+StatusBarHeight, SCREEN_WIDTH, SCREEN_HEIGHT-64-70-5);
}

#pragma mark - get channel type
- (ChannelType)getChannelType:(int)cid
{
    ChannelType type;
    switch (cid) {
        case 18:
            type = ChannelType_Local;
            break;
        case 19:
            type = ChannelType_Top;
            break;
        case 20:
            type = ChannelType_Collection;
            break;
        case 21:
            type = ChannelType_Internal;
            break;
        case 15:
            type = ChannelType_Foreign;
            break;
        case 2:
            type = ChannelType_Music;
            break;
        case 1:
            type = ChannelType_News;
            break;
        case 4:
            type = ChannelType_Transport;
            break;
        case 3:
            type = ChannelType_Economy;
            break;
        case 7:
            type = ChannelType_Sports;
            break;
        case 6:
            type = ChannelType_Opera;
            break;
        case 11:
            type = ChannelType_Travel;
            break;
    }

    return type;
}


#pragma mark - memory

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
