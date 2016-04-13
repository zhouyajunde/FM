//
//  baseHasNoChildController.m
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "baseHasNoChildController.h"
#import "ZWCollectionViewFlowLayout.h"
#import "UserDefine.h"
#import "hasChildCollectionViewCell.h"
#import "MJExtension.h"
#import "haschildViewController.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

static NSString *cellIdentifier = @"cellIdentifier";

@interface baseHasNoChildController ()<ZWwaterFlowDelegate>
{
     
    ZWCollectionViewFlowLayout *_flowLayout;//自定义layout
    
    int a;

}
@end

@implementation baseHasNoChildController

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    _allGroups = [NSMutableArray array];
//    [self initContentView];
//    
//}
- (void)loadView
{
    _allGroups = [NSMutableArray array];
    
    _flowLayout = [[ZWCollectionViewFlowLayout alloc] init];
    _flowLayout.colMagrin = 5;
    _flowLayout.rowMagrin = 5;
    _flowLayout.sectionInset = UIEdgeInsetsMake(2, 10, 2, 10);
    _flowLayout.colCount = 3;
    _flowLayout.degelate = self;
    
    _CollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width,  [UIScreen mainScreen].bounds.size.height) collectionViewLayout:_flowLayout];
    
    //注册显示cell的类型
    UINib *cellNib=[UINib nibWithNibName:@"hasChildCollectionViewCell" bundle:nil];
    [_CollectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    
    _CollectionView.delegate=self;
    _CollectionView.dataSource=self;
    
    _CollectionView.bounces=YES;
    _CollectionView.scrollEnabled=YES;
    _CollectionView.showsVerticalScrollIndicator=NO; //指示条
    _CollectionView.backgroundColor=[UIColor clearColor];
    
    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    　
    self.view = view;
  
    [self.view addSubview:_CollectionView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 388*KWidth_Scale-1, screen_width, 1)];
    lineView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lineView];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _allGroups.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    hasChildCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"%@",_allGroups[indexPath.item]);
    
    cell.model= [hasDiquModel mj_objectWithKeyValues: _allGroups[indexPath.item]];
    
    cell.section= indexPath;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    hasDiquModel *chanelD=[hasDiquModel mj_objectWithKeyValues: _allGroups[indexPath.item]];

    haschildViewController *has = [[haschildViewController alloc]init];
    has.title = chanelD.name;
    has.pagN =  [NSString stringWithFormat:@"%@", chanelD.id];
   
    [self.navigationController pushViewController:has animated:YES];
//    [self.delegate fenleiTableCellDelegate:chanelD];
//    
//    NSLog(@"cc:%ld--%ld",(long)indexPath.section,indexPath.item);
}


#pragma mark ZWwaterFlowDelegate
- (CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach
{
    //    return (500*KWidth_Scale-3*5)/3;
    
    return 45*KWidth_Scale;
    
}



- (void)awakeFromNib {
    // Initialization code
}


@end
