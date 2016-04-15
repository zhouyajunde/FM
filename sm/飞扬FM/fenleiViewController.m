//
//  fenleiViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "fenleiViewController.h"
#import "RecommendHeadView.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "diquCollectionViewCell.h"
#import "zhiboTableViewCell.h"
#import "feIleizhiboCell.h"
#import "fenleiTableViewCell.h"
#import "MJExtension.h"
#import "MainzhiboTableViewCell.h"
#import "fenleizhiboViewController.h"
#import "diquModel.h"
#import "haschildViewController.h"
#import "hasNoChildViewController.h"
#import "HMPlayingViewController.h"

#import "HMMusicTool.h"


//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f


//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


@interface fenleiViewController ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,fenleiTableCellDelegate,zhiboDelegate>{
    
    UITableView *_tableView;
  
    
    fenleizhiboViewController *_moreVC;
    RecommendHeadView *_CellHeadView;
    
    NSMutableArray *_diquArray;
    NSMutableArray *_fenliArray;
    NSMutableArray *_zhiboArray;
    
    NSMutableArray *_totalArray;
}

@end

@implementation fenleiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self loadTotal];
    [self initTableView];
    
    _diquArray = [NSMutableArray array];
    _fenliArray = [NSMutableArray array];
    _zhiboArray = [NSMutableArray array];
    
    _totalArray = [NSMutableArray array];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)loadTotal
{
    
    [[HTTPManager shareManager]getPath:fenleiListURl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *jsonData = responseObject;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObj;
        NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
        
        _diquArray = [deserializedDictionary objectForKey:@"diqu"];
        
        _fenliArray = [deserializedDictionary objectForKey:@"fenlei"];
        
        _zhiboArray = [deserializedDictionary objectForKey:@"zhibo"];
        
        [_totalArray addObject:_diquArray];
        
        [_totalArray addObject:_fenliArray];
        
        [_totalArray addObject:_zhiboArray];

        [self.view addSubview:_tableView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

}

-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64-90) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_totalArray.count) {
        
        return _totalArray.count;
    }else{
        
        return 1;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 40*KWidth_Scale;
    }else if (indexPath.section==1){
        
        return 85*KWidth_Scale;
    }else{
        return 810*KWidth_Scale;
    }
    
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld,%ld",indexPath.section,indexPath.row);
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {
        
        fenleiTableViewCell *cell = [fenleiTableViewCell shoucangCellWithTabView:tableView];
        
        cell.modelArray=[diquModel mj_objectArrayWithKeyValuesArray:_diquArray];
        cell.delegate=self;
        cell.tags=(int)indexPath.section-1;

        cell.delegate = self;
        return cell;
        
    }else if (indexPath.section==1) {
        
        fenleiTableViewCell *cell = [fenleiTableViewCell shoucangCellWithTabView:tableView];
        cell.modelArray=[diquModel mj_objectArrayWithKeyValuesArray:_fenliArray];
        cell.delegate=self;
        cell.tags=(int)indexPath.section-1;

        return cell;
        
    }else{
        
        MainzhiboTableViewCell *cell = [MainzhiboTableViewCell shoucangCellWithTabView:tableView];
        
        cell.modelArray = [scModel mj_objectArrayWithKeyValuesArray:_zhiboArray];
        
        cell.delegate = self;
        return cell;
    }
    
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    _CellHeadView=[[RecommendHeadView alloc]init];
    _CellHeadView.tag=section;
    
    
    if (section==0) {
        _CellHeadView.Title.text=@"地区";
        
        _CellHeadView.more.hidden=YES;
        _CellHeadView.moreimage.hidden=YES;
    }else if(section==1){
        
        _CellHeadView.more.hidden=YES;
        _CellHeadView.moreimage.hidden=YES;
//        NSArray *array=_ChanelDataArray[section-1];
        _CellHeadView.Title.text=@"分类";
//        UITapGestureRecognizer *tapHeadView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
//        tapHeadView.delegate=self;
//        [_CellHeadView addGestureRecognizer:tapHeadView];
    }else{
        _CellHeadView.Title.text=@"正在直播";
        
        UITapGestureRecognizer *tapHeadView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
        tapHeadView.delegate=self;
        [_CellHeadView addGestureRecognizer:tapHeadView];
    }
    return _CellHeadView;
}

-(void)tapHeadView:(UIGestureRecognizer*)sender
{
    
//    NSArray *array=_ChanelDataArray[sender.view.tag];
//    
    _moreVC=[[fenleizhiboViewController alloc]init];
    _moreVC.title=@"正在直播";
    _moreVC.array=_zhiboArray;
    
    [self setHidesBottomBarWhenPushed:YES];
    
    [_delegate TomoreView:_moreVC];
}

-(void)fenleiTableCellDelegate:(diquModel *)chaneldata
{
    NSLog(@"%@",chaneldata);
    
    if ([chaneldata.haschild isEqualToString:@"0"]) {
        haschildViewController *has = [[haschildViewController alloc]init];
        has.title = chaneldata.name;
        has.pagN =  [NSString stringWithFormat:@"%d", chaneldata.id];
        [self.delegate TomoreView:has];
    }else
    {
        hasNoChildViewController * hasNo = [[hasNoChildViewController alloc]init];
        hasNo.title = chaneldata.name;
        hasNo.model = chaneldata;
        [self.delegate TomoreView:hasNo];
    }
    
}

-(void)TapRecommendTableCellDelegate:(scModel *)chaneldata musicNarrry:(NSArray *)musicArry
{
    HMPlayingViewController *playingVc = [HMPlayingViewController musicView];
    
    [HMMusicTool setPlayingMusic:chaneldata];
    
    [HMMusicTool setAllMusic:musicArry];
    
    [self.delegate MusicView:playingVc];

}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        
        return YES;
    }
    
    return YES;
}

@end
