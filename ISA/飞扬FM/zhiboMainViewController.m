//
//  zhiboMainViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "zhiboMainViewController.h"
#import "MJExtension.h"
#import "UserDefine.h"
#import "scModel.h"
#import "zhiboTableViewCell.h"
#import "HMPlayingViewController.h"

#import "HMMusicTool.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

const int   ppTableViewHeaderH = 35;

@interface zhiboMainViewController ()

@property(nonatomic, strong)scModel *chaneldata;
@end

@implementation zhiboMainViewController

- (void)loadView
{
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
    tableView.sectionHeaderHeight = ppTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(ppTableViewHeaderH-35, 0, 0, 0);
    }
    
    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
    　
    self.view = view;
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    _tableView = tableView;
    
    //     self.view = tableView;
    [self.view addSubview:_tableView];
}

//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    _allGroups = [NSMutableArray array];
//    
//    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
//    
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    
//    // 设置背景
//    tableView.backgroundView = nil;
//    tableView.backgroundColor = [UIColor clearColor];
//    // 分隔线
//    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    
//    tableView.sectionFooterHeight = 0;
//    tableView.sectionHeaderHeight = ppTableViewHeaderH;
//    
//    if (iOS7) {
//        tableView.contentInset = UIEdgeInsetsMake(ppTableViewHeaderH-35, 0, 0, 0);
//    }
//    
//    UIView *view　= [[UIView alloc] initWithFrame:[ UIScreen mainScreen] .applicationFrame] ;
//    　
//    self.view = view;
//    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
//    _tableView = tableView;
//    
//    //     self.view = tableView;
//    [self.view addSubview:_tableView];
//
//}

#pragma mark - 数据源

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90*KWidth_Scale;
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
    
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.model = [scModel mj_objectWithKeyValues:sc];
    
    self.chaneldata = [scModel mj_objectWithKeyValues:sc];
    //返回
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
     NSLog(@"11");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HMPlayingViewController *playingVc = [HMPlayingViewController musicView];
    
    [HMMusicTool setPlayingMusic: [scModel mj_objectWithKeyValues:_allGroups[indexPath.row]]];
    
    [HMMusicTool setAllMusic: [scModel mj_objectArrayWithKeyValuesArray: _allGroups]];
    
    [self presentViewController:playingVc animated:YES completion:nil];

}

@end
