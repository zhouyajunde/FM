//
//  fenleiTableViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "fenleiTableViewCell.h"
#import "diquCollectionViewCell.h"
#import "ZWCollectionViewFlowLayout.h"
#import "diquModel.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

static NSString *cellIdentifier = @"cellIdentifier";

@interface fenleiTableViewCell () <ZWwaterFlowDelegate>
{
    UICollectionView *_CollectionView;
    
    ZWCollectionViewFlowLayout *_flowLayout;//自定义layout
    
    int a;
}

@end

@implementation fenleiTableViewCell


+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    fenleiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        
        cell=[[fenleiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        
        cell.backgroundColor = [UIColor clearColor];
//         cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];

//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

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
    _flowLayout.colMagrin = 0;
    _flowLayout.rowMagrin = 0;
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);
    _flowLayout.colCount = 4;
    _flowLayout.degelate = self;
    
    _CollectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 388*KWidth_Scale) collectionViewLayout:_flowLayout];
    
    //注册显示cell的类型
    UINib *cellNib=[UINib nibWithNibName:@"diquCollectionViewCell" bundle:nil];
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
    return _modelArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //重用cell
    diquCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    NSLog(@"%@",self.modelArray[indexPath.item]);
    
    cell.model=self.modelArray[indexPath.item];
    
    cell.section= indexPath;
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        diquModel *chanelD=self.modelArray[indexPath.item];
    
        [self.delegate fenleiTableCellDelegate:chanelD];
    
        NSLog(@"cc:%ld--%ld",(long)indexPath.section,indexPath.item);
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    NSLog(@"22");
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
