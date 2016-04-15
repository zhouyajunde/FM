//
//  MoreViewController.m
//  DouYU
//
//  Created by Alesary on 15/11/3.
//  Copyright © 2015年 Alesary. All rights reserved.
//

#import "MoreViewController.h"
#import "ZWCollectionViewFlowLayout.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "ColumnViewCell.h"
#import "scModel.h"
#import "moreCollectionViewCell.h"
#import "HMPlayingViewController.h"
#import "HMMusicTool.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

static NSString *cellIdentifier = @"moreCollectionViewCell";


@interface MoreViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,ZWwaterFlowDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;
    
    ZWCollectionViewFlowLayout *_flowLayout;//自定义layout
    
    int times; //记录上拉的次数
    
}


@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    [self initCollectionView];
    [self loadData];
    [self loadMoreData];
    _dataArray = _Cate_id;
}

-(void)loadData
{
}

-(void)loadMoreData
{
}

-(void)initCollectionView
{
    //初始化自定义layout
    _flowLayout = [[ZWCollectionViewFlowLayout alloc] init];
    _flowLayout.colMagrin = 5;
    _flowLayout.rowMagrin = 5;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 5, 10);
    _flowLayout.colCount = 3;
    _flowLayout.degelate = self;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screen_width,  [UIScreen mainScreen].bounds.size.height) collectionViewLayout: _flowLayout];
    //注册显示的cell的类型
 
    UINib *cellNib=[UINib nibWithNibName:@"moreCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled=YES;
    _collectionView.bounces=YES;
    _collectionView.showsVerticalScrollIndicator=YES; //指示条
    _collectionView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
//    ColumnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    moreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *array= [scModel  mj_objectArrayWithKeyValuesArray: _dataArray];
    
    cell.model= array[indexPath.item];
    
    return cell;
}
#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"你点击了 %ld--%ld",(long)indexPath.section,indexPath.item);
    HMPlayingViewController *playingVc = [HMPlayingViewController musicView];
    
    [HMMusicTool setPlayingMusic:[scModel mj_objectArrayWithKeyValuesArray: _dataArray][indexPath.item]];
    
    [HMMusicTool setAllMusic: [scModel mj_objectArrayWithKeyValuesArray: _dataArray]];
    
    [self presentViewController:playingVc animated:YES completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 388*KWidth_Scale;
}

#pragma mark ZWwaterFlowDelegate
- (CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach
{
    
    return 155*KWidth_Scale;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
