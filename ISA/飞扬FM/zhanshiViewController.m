//
//  zhanshiViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "zhanshiViewController.h"
#import "UserDefine.h"
#import "scTableViewCell.h"
#import "MJExtension.h"
#import "scModel.h"
#import "zhiboTableViewCell.h"
#import "HMPlayingViewController.h"

#import "HMMusicTool.h"
//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

const int   ZTableViewHeaderH = 35;


@interface zhanshiViewController ()
{
      
}

@property(nonatomic, strong)scModel *chaneldata;
@end

@implementation zhanshiViewController


- (void)loadView
{
    
    _editArray = [NSMutableArray array];
    _allGroups = [NSMutableArray array];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置背景
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    // 分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = ZTableViewHeaderH;
    tableView.allowsMultipleSelectionDuringEditing = YES;
    tableView.allowsSelectionDuringEditing = YES;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(ZTableViewHeaderH-35, 0, 0, 0);
    }
    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    　
    self.view = view;
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    _tableView = tableView;
    
    //     self.view = tableView;
    [self.view addSubview:_tableView];
}

#pragma mark - 数据源

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*KWidth_Scale;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    //    return editingStyle;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _allGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //1 创建可重用的自定义的cell
    
    zhiboTableViewCell *cell = [zhiboTableViewCell shoucangCellWithTabView:tableView];
    //2 设置cell内部的子控件
    
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.model = [scModel mj_objectWithKeyValues:sc];
    
    self.chaneldata = [scModel mj_objectWithKeyValues:sc];
    //返回
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (self.tableView.editing) {
        
        NSLog(@"%ld",(long)indexPath.row);
        
        [_editArray addObject:[NSString stringWithFormat:@"%@",[scModel mj_objectWithKeyValues:_allGroups[indexPath.row]].id]];
        
    }else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        HMPlayingViewController *playingVc = [HMPlayingViewController musicView];
        
        [HMMusicTool setPlayingMusic: [scModel mj_objectWithKeyValues:_allGroups[indexPath.row]]];
        
        [HMMusicTool setAllMusic: [scModel mj_objectArrayWithKeyValuesArray: _allGroups]];
        
        [self presentViewController:playingVc animated:YES completion:nil];
     
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [_editArray removeObject:[NSString stringWithFormat:@"%@",[scModel mj_objectWithKeyValues:_allGroups[indexPath.row]].id]];
    
}

@end
