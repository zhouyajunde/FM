//
//  tuijianViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "tuijianViewController.h"
#import "UserDefine.h"
#import "CollectionViewCell.h"
#import "HTTPManager.h"
#import "XLPlainFlowLayout.h"
#import "musicModel.h"
#import "scModel.h"
#import "ZYJCollectionViewCell.h"
#import "MJExtension.h"
#import "SDCycleScrollView.h"
#import "RecommendHeadView.h"
#import "TOPdata.h"
#import "RecommendTableCell.h"
#import "topOneCell.h"
#import "MoreViewController.h"
#import "HMPlayingViewController.h"

#import "HMMusicTool.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f


//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

NSString * const ILId = @"cell";

@interface tuijianViewController ()<SDCycleScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,RecommendTableCellDelegate,UICollectionViewDataSource,UICollectionViewDelegate,topDelegate>{
    UITableView *_tableView;
    
    SDCycleScrollView *_headView;
    
    RecommendHeadView *_CellHeadView;
    
    MoreViewController *_moreVC;
    
    NSMutableArray *_topDataArray;
    NSMutableArray *_imageArray;
    NSMutableArray *_titleArray;
    
    NSMutableArray *_NewDataArray;
    
    NSMutableArray *_ChanelDataArray;
    NSMutableArray *_ChanelDatas;
    NSMutableArray *_TopDatas;
    NSMutableArray *_SudiDatas;


}

@property (nonatomic, strong) HMPlayingViewController *playingVc;
@property (nonatomic, strong) NSMutableArray *apps;

@end

@implementation tuijianViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadChanelData];
    
    [self loadTopData];
    [self loadNewShowData];
    
    [self initHeadView];
    [self initTableView];
    
    _topDataArray=[NSMutableArray array];
    _imageArray=[NSMutableArray array];
    _titleArray=[NSMutableArray array];
    _NewDataArray=[NSMutableArray array];
    
    _ChanelDataArray=[NSMutableArray array];
    _ChanelDatas=[NSMutableArray array];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];

    
}
//documentDirectory	NSPathStore2 *	@"/Users/mac/Library/Developer/CoreSimulator/Devices/A6931823-17BA-46D8-BE58-A81B779251C2/data/Containers/Data/Application/2742A8C8-D428-4B8F-BEE6-57FE8C3F480E/Documents"	0x00007fa73961f5f0
-(void)loadNewShowData
{
}

-(void)loadChanelData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *loc = [defaults objectForKey:@"dingwei"];
    
    NSString *locc = [loc objectForKey:@"loc"];
    
    NSString *place = [loc objectForKey:@"place"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

    parameters[@"localtion"] = place;
    
//    NSDictionary *parameters = @{@"localtion":place};
    
    [[HTTPManager shareManager]getPath:tuijianListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *jsonData = responseObject;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *deserializedDictionary = (NSDictionary *)jsonObj;
        NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
        
        NSDictionary *dic= [deserializedDictionary objectForKey:@"top1"];
        
        NSMutableArray * ary = [NSMutableArray new];
        
        [ary addObject:dic];
        
        _TopDatas = ary;
        
        _ChanelDatas=[[deserializedDictionary objectForKey:@"jinxuan"] objectForKey:@"diantai"];
        
        _SudiDatas=[[deserializedDictionary objectForKey:@"sudi"]objectForKey:@"diantai"];
        
        [_ChanelDataArray addObject:_TopDatas];
    
        [_ChanelDataArray addObject:_ChanelDatas];

        [_ChanelDataArray addObject:_SudiDatas];

        [self.view addSubview:_tableView];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//图片轮播
-(void)loadTopData
{
    
    [[HTTPManager shareManager]getPath:imgsixURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//其实这几把就是扯淡没什么卵用，写这么多！！
        NSData *jsonData = responseObject;
        id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        NSMutableArray *deserializedDictionary = (NSMutableArray *)jsonObj;
        
        _topDataArray=[TOPdata mj_objectArrayWithKeyValuesArray:deserializedDictionary];
        
        for (TOPdata *topdata in _topDataArray) {
            
            NSString *url = [NSString stringWithFormat:@"%@%@",six,topdata.url];
            
            [_imageArray addObject:url];
        }
        
        _headView.imageURLStringsGroup = _imageArray;
        
        NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     
    }];
}

-(void)initTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, screen_height-64-90) style:UITableViewStyleGrouped];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.tableHeaderView=_headView;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
}
-(void)initHeadView
{
    
    _headView=[SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, screen_width, 160*KWidth_Scale) imagesGroup:_imageArray];
    _headView.titlesGroup=_titleArray;
    _headView.placeholderImage=[UIImage imageNamed:@"diantai_default.png"];
    _headView.delegate=self;
    _headView.pageControlStyle=SDCycleScrollViewPageContolStyleClassic;
    _headView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _headView.titleLabelTextFont=[UIFont systemFontOfSize:17];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_ChanelDataArray.count) {
        
        return _ChanelDataArray.count;
    }else{
        
        return 1;
    }
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        return 70*KWidth_Scale;
    }else{
        
        return 330*KWidth_Scale;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.playingVc = [HMPlayingViewController musicView];
    
    [HMMusicTool setPlayingMusic:[scModel mj_objectWithKeyValues:_TopDatas[0]]];
    
    [HMMusicTool setAllMusic:nil];
    
    [self.delegate MusicView:self.playingVc];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0) {

        topOneCell *cell = [topOneCell shoucangCellWithTabView:tableView];
        
        NSDictionary *sc =  _TopDatas[0];
        
        cell.model = [scModel mj_objectWithKeyValues:sc];
        
        cell.delegate = self;
        return cell;
    
    }else{
        
        static NSString *identfire=@"RecommendTableCell";
        
        RecommendTableCell *cell=[tableView dequeueReusableCellWithIdentifier:identfire];
        
        if (!cell) {
            
            cell=[[RecommendTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identfire];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.backgroundColor = [UIColor clearColor];
        
        NSLog(@"%@",_ChanelDataArray);
        
        NSLog(@"%ld",(long)indexPath.section);
        
        NSArray *array=_ChanelDataArray[indexPath.section];
        
        cell.modelArray=[scModel mj_objectArrayWithKeyValuesArray:array];
;
        cell.delegate=self;
        cell.tags=(int)indexPath.section-1;
        
        return cell;
    }
    
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 7;
    }else{
        return 30;
    }
 
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
        _CellHeadView.Title.text=@"";
        _CellHeadView.more.hidden=YES;
        _CellHeadView.moreimage.hidden=YES;
        
    }else if(section==1){
        
        NSArray *array=_ChanelDataArray[section-1];
        _CellHeadView.Title.text=@"电台精选";
        UITapGestureRecognizer *tapHeadView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
        tapHeadView.delegate=self;
        [_CellHeadView addGestureRecognizer:tapHeadView];
    }else{
         _CellHeadView.Title.text=@"本地台";
        
        UITapGestureRecognizer *tapHeadView=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHeadView:)];
        tapHeadView.delegate=self;
        [_CellHeadView addGestureRecognizer:tapHeadView];
    }
    return _CellHeadView;
}

-(void)tapHeadView:(UIGestureRecognizer*)sender
{
    
    NSArray *array=_ChanelDataArray[sender.view.tag];
    
    _moreVC=[[MoreViewController alloc]init];
    _moreVC.title=@"电台精选";
    _moreVC.Cate_id=array;

//    [self setHidesBottomBarWhenPushed:YES];
    
    [_delegate TomoreView:_moreVC];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isMemberOfClass:[UIButton class]]) {
        
        return YES;
    }
    
    return YES;
}

-(void)TapRecommendTableCellDelegate:(scModel *)chaneldata musicNarrry:(NSArray *)musicArry{
    
    self.playingVc = [HMPlayingViewController musicView];
   
    self.playingVc.musicList = chaneldata;
   
    [HMMusicTool setPlayingMusic:chaneldata];
    
    [HMMusicTool setAllMusic:musicArry];
    
    [self.delegate MusicView:self.playingVc];
    
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
//    TOPdata *topdata=_topDataArray[index];
//    
//    PlayerController *playVC=[[PlayerController alloc]init];
//    
//    NSLog(@"%@",[topdata.room objectForKey:@"hls_url"]);
//    
//    playVC.Hls_url=[topdata.room objectForKey:@"hls_url"];
//    
//    [self setHidesBottomBarWhenPushed:YES];
//    [self presentViewController:playVC animated:YES completion:nil];
    
    
}

@end
