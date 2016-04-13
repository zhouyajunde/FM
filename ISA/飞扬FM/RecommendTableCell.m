//
//  RecommendTableCell.m
//  DouYU
//
//  Created by admin on 15/11/1.
//  Copyright © 2015年 Alesary. All rights reserved.
//

#import "RecommendTableCell.h"
#import "FourCollectionCell.h"
#import "ZWCollectionViewFlowLayout.h"
#import "ColumnViewCell.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height


static NSString *cellIdentifier = @"cellIdentifier";

@interface RecommendTableCell () <ZWwaterFlowDelegate>
{
     UICollectionView *_CollectionView;
    
     ZWCollectionViewFlowLayout *_flowLayout;//自定义layout
    
    int a;
}

@end

@implementation RecommendTableCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self initContentView];
        
        
    }
    
    return self;
}


-(void)initContentView
{

    //初始化自定义layout
    _flowLayout = [[ZWCollectionViewFlowLayout alloc] init];
    _flowLayout.colMagrin = 5;
    _flowLayout.rowMagrin = 5;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _flowLayout.colCount = 3;
    _flowLayout.degelate = self;
   
    _CollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 395*KWidth_Scale) collectionViewLayout:_flowLayout];
    
    //注册显示cell的类型
    UINib *cellNib=[UINib nibWithNibName:@"ColumnViewCell" bundle:nil];
    [_CollectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    
    _CollectionView.delegate=self;
    _CollectionView.dataSource=self;
    
    _CollectionView.bounces=NO;
    _CollectionView.scrollEnabled=NO;
    _CollectionView.showsVerticalScrollIndicator=NO; //指示条
    _CollectionView.backgroundColor=[UIColor clearColor];
    
    [self addSubview:_CollectionView];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 388*KWidth_Scale-1, screen_width, 1)];
    lineView.backgroundColor=[UIColor clearColor];
    [self addSubview:lineView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    //重用cell
    ColumnViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"%@",self.modelArray[indexPath.item]);
    
    cell.model=self.modelArray[indexPath.item];
    
//    cell.chaneldata=self.modelArray[indexPath.item];
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    scModel *chanelD=self.modelArray[indexPath.item];
    
    [self.delegate TapRecommendTableCellDelegate:chanelD musicNarrry:self.modelArray];
    
    NSLog(@"cc:%ld--%ld",(long)indexPath.section,indexPath.item);
}


#pragma mark ZWwaterFlowDelegate
- (CGFloat)ZWwaterFlow:(ZWCollectionViewFlowLayout *)waterFlow heightForWidth:(CGFloat)width atIndexPath:(NSIndexPath *)indexPach
{
//    return (500*KWidth_Scale-3*5)/3;
    
     return 155*KWidth_Scale;

}
@end
