//
//  hasNoChildViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/3/3.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "hasNoChildViewController.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "MJExtension.h"
#import "BSHeader.h"
#import "BSFooter.h"

@interface hasNoChildViewController ()
{
    NSString *pagN;
    int times; //记录上拉的次数
}
@property (nonatomic, weak) HTTPManager *mgr;
@end

@implementation hasNoChildViewController

- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    
    [self setUpRefresh];
    
    times=1;
}

- (void)setUpRefresh
{
    self.CollectionView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.CollectionView.mj_header beginRefreshing];
    
//    self.CollectionView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadNewTopics
{
    
        NSString *time=[NSString stringWithFormat:@"%d",times];
    
        NSString *a = @"40";
    
        NSDictionary *parameters = @{@"id":pagN,@"pageNo":time,@"pageSize":a};
        
        [self.mgr getPath:fenliListUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
                //字典数组转模型数组
                
                if (_allGroups.count == 0) {
                    for (hasDiquModel *ary  in  [detailNSArray objectForKey:@"list"]) {
                        //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                        [_allGroups addObject:ary];
                    }
                    
                    [self.CollectionView reloadData];
                }
//
                // 结束刷新
                [self.CollectionView.mj_header endRefreshing];
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ss");
            // 结束刷新
            [self.CollectionView.mj_header endRefreshing];
        }];
}

- (void)loadMoreTopics
{
//    times += 1;
//    
//    NSString *time=[NSString stringWithFormat:@"%d",times];
//    
//    NSDictionary *parameters = @{@"id":pagN,@"pageNo":time };
//    
//    [self.mgr getPath:fenliListUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSError *error = nil;
//        
//        NSData *jsonData = responseObject;
//        
//        if ([jsonData length]>0 && error == nil) {
//            
//            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *detailNSArray = (NSDictionary *)jsonObj;
//            //字典数组转模型数组
//            for (hasDiquModel *ary  in  [detailNSArray objectForKey:@"list"]) {
//                //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
//                [_allGroups addObject:ary];
//            }
//            
//            [self.CollectionView reloadData];
//            
//            // 结束刷新
//            [self.CollectionView.mj_footer endRefreshing];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"ss");
//        // 结束刷新
//        [self.CollectionView.mj_footer endRefreshing];
//        
//    }];
}


-(void)setModel:(diquModel *)model
{
    pagN = [NSString stringWithFormat:@"%d",model.id];
    
}


@end
