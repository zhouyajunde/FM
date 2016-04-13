//
//  haschildViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/28.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "haschildViewController.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "MJExtension.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD+NJ.h"


@interface haschildViewController ()<CLLocationManagerDelegate>{
       int times; //记录上拉的次数
}
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, weak) HTTPManager *mgr;
@end

@implementation haschildViewController

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
    
    times=1;
}

// 当地的电台的处理
-(void)dingwei{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *loc = [defaults objectForKey:@"dingwei"];
    
    NSString *locc = [loc objectForKey:@"loc"];
    
    NSString *place = [loc objectForKey:@"place"];
    
    NSMutableDictionary *parameters  = [NSMutableDictionary dictionary];
    
    parameters[@"fenleiId"] = _pagN;
    parameters[@"pageNo"] = [NSString stringWithFormat:@"%d",times];
    parameters[@"localtion"] = place;
//    parameters[@"place"] = @"内蒙古";
    
    if (locc == nil) {
        locc = @"";
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请打开定位，收听本地台"];
        return;
    }
//if (place == nil) {
//        place = @"";
//        [MBProgressHUD hideHUD];
//        [MBProgressHUD showError:@"请打开定位，收听本地台"];
//        return;
//    }
    [self.mgr getPath:subfenleiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (void)setUpRefresh
{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}
- (void)loadNewTopics
{
    if ([_pagN isEqualToString:@"14"]) {
        
          [self dingwei];
        
    }else{
        
        NSString *time=[NSString stringWithFormat:@"%d",times];
        
        
        NSDictionary *parameters = @{@"fenleiId":_pagN,@"pageNo":time };
        
        [self.mgr getPath:subfenleiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
}

- (void)loadMoreTopics
{
    times += 1;
    
    NSString *time=[NSString stringWithFormat:@"%d",times];
    
    
    NSDictionary *parameters = @{@"fenleiId":_pagN,@"pageNo":time };
    
    [self.mgr getPath:subfenleiUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

//-(void)setModel:(diquModel *)model
//{
//    pagN = [NSString stringWithFormat:@"%d",model.id];
//    
//}

@end
