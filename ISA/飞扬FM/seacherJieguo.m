//
//  seacherJieguo.m
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "seacherJieguo.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "MMLabel.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "MJExtension.h"
#import "MBProgressHUD+NJ.h"
#import "scModel.h"

@interface seacherJieguo ()
{
    NSString *pagN;
    int times; //记录上拉的次数

}


@property (nonatomic, weak) HTTPManager *mgr;

@end

@implementation seacherJieguo

#pragma mark - 懒加载
- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self setUpRefresh];
   [self loadNewTopics];
}

- (void)setUpRefresh
{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
//    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
- (void)loadNewTopics
{
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    
    parameters[@"keyword"] = _name;
    parameters[@"pageNo"] = [NSString stringWithFormat:@"%d",times];
    
    
    [self.mgr postPath:sousuoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
      
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
            
            [_allGroups removeAllObjects];
            //字典数组转模型数组
            for (scModel *ary  in  [detailNSArray objectForKey:@"list"]) {
                //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                [_allGroups addObject:ary];
            }
            
            [self.tableView reloadData];
            
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        NSLog(@"ss");
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}
- (void)loadMoreTopics
{
        times += 1;
    
        NSString *time=[NSString stringWithFormat:@"%d",times];
   
        NSDictionary *parameters = @{@"keyword":_name,@"pageNo":time };
    
        [self.mgr postPath:sousuoUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
    
            NSData *jsonData = responseObject;
    
            if ([jsonData length]>0 && error == nil) {
    
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
                //字典数组转模型数组
                for (scModel *ary  in  [detailNSArray objectForKey:@"list"]) {
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


@end
