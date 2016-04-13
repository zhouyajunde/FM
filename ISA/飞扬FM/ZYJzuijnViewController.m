//
//  ZYJzuijnViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJzuijnViewController.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "scModel.h"
#import "MJExtension.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "ZYJdic.h"

@interface ZYJzuijnViewController()
{
    NSString *pagN,*_userId;
    int times; //记录上拉的次数

}

@property (nonatomic, weak) HTTPManager *mgr;

@end
@implementation ZYJzuijnViewController

- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}

-(void)viewDidLoad{
    
    [super viewDidLoad];
     // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _userId = [_dic objectForKey:@"id"];
    times=1;
    
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
    if (_userId == nil) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    
    NSString *time=[NSString stringWithFormat:@"%d",times];
    
    
    NSDictionary *parameters = @{@"userId":_userId,@"pageNo":time };
    
   
    [self.mgr getPath:shoutingListUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
            //字典数组转模型数组
            if (_allGroups.count == 0) {

            for (scModel *ary  in  [detailNSArray objectForKey:@"list"]) {
                //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                [_allGroups addObject:ary];
            }
            
            [self.tableView reloadData];
            }
            // 结束刷新
            [self.tableView.mj_header endRefreshing];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreTopics
{
    times += 1;
    
    NSString *time=[NSString stringWithFormat:@"%d",times];
    
    
    NSDictionary *parameters = @{@"userId":_userId,@"pageNo":time };
    
    [self.mgr getPath:shoutingListUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
