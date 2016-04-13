//
//  MainzhiboTableViewCell.m
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "MainzhiboTableViewCell.h"
//#import "zhiboTableViewCell.h"
#import "feIleizhiboCell.h"
#import "MJExtension.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f
//设备物理尺寸
#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height

@interface MainzhiboTableViewCell(){

    UITableView *_CollectionView;
}


@end

@implementation MainzhiboTableViewCell



+(instancetype)shoucangCellWithTabView:(UITableView*)tableView
{
    static NSString *reuseId = @"gb";
    MainzhiboTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        
        cell=[[MainzhiboTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
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
    
    _CollectionView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, screen_width, 800*KWidth_Scale) style:UITableViewStylePlain];
    
    //注册显示cell的类型
    
    _CollectionView.delegate=self;
    _CollectionView.dataSource=self;
    
 //去除线
    _CollectionView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _CollectionView.bounces=NO;
    _CollectionView.scrollEnabled=NO;
    _CollectionView.showsVerticalScrollIndicator=NO; //指示条
    _CollectionView.backgroundColor=[UIColor clearColor];
    
//    _CollectionView=UITableViewCellSelectionStyleNone;
    [self addSubview:_CollectionView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     return 90*KWidth_Scale;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    
    feIleizhiboCell *cell = [feIleizhiboCell shoucangCellWithTabView:tableView];
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    NSDictionary *sc = _modelArray[indexPath.row];
    
    
    cell.model=[scModel mj_objectWithKeyValues:sc];
    
    //返回
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    scModel *chanelD=self.modelArray[indexPath.item];
    
    [self.delegate TapRecommendTableCellDelegate:chanelD musicNarrry:self.modelArray];
}


- (void)awakeFromNib {
    // Initialization code
}

@end
