//
//  ZYJchangjian.m
//  飞扬FM
//
//  Created by Mac os on 16/1/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJchangjian.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MJExtension.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "changjianCell.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

const int   ppppTableViewHeaderH = 35;

@implementation ZYJchangjian

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置背景
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    // 分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = ppppTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(ppppTableViewHeaderH-35, 0, 0, 0);
    }
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    _tableView = tableView;
    
    _allGroups = [NSMutableArray array];
    //     self.view = tableView;
    [self.view addSubview:_tableView];
    
    times = 1;
    
    [self setUpRefresh];

}

-(void)viewDidAppear:(BOOL)animated
{
    [self loadNewTopics];
}


- (void)setUpRefresh
{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}


- (void)loadNewTopics
{

    
    NSString *time=[NSString stringWithFormat:@"%d",times];
    
    NSDictionary *parameters = @{@"pageNo":time };
    
    [[HTTPManager shareManager]  getPath:quaURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
            //字典数组转模型数组
            for (changjianModel *ary  in  [detailNSArray objectForKey:@"list"]) {
                //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                [_allGroups addObject:ary];
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];
    
}
- (void)loadMoreTopics
{
    times += 1;
    
    NSString *time=[NSString stringWithFormat:@"%d",times];
    
    NSDictionary *parameters = @{@"pageNo":time };
    
    [[HTTPManager shareManager]  getPath:quaURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
            //字典数组转模型数组
            for (changjianModel *ary  in  [detailNSArray objectForKey:@"list"]) {
                //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                [_allGroups addObject:ary];
            }
            
            [self.tableView reloadData];
            
            // 结束刷新
            [self.tableView.mj_footer endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - 数据源

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120*KWidth_Scale;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _allGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    
    changjianCell *cell = [changjianCell shoucangCellWithTabView:tableView];
    //2 设置cell内部的子控件
    
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.model = [changjianModel mj_objectWithKeyValues:sc];
    
    //返回
    return cell;
}

@end
