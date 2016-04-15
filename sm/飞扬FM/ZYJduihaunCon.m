//
//  ZYJduihaunCon.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJduihaunCon.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MJExtension.h"
#import "duihuanModel.h"
#import "huanCell.h"
#import "header.h"
#import "MBProgressHUD+NJ.h"


//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

const int   poTableViewHeaderH = 35;

@interface ZYJduihaunCon()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_userId,*_jifen;
    duihuanModel *_dhjifen;
}
- (IBAction)zijiBtn:(id)sender;

@end

@implementation ZYJduihaunCon


-(void)viewDidLoad
{
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
    tableView.sectionHeaderHeight = poTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(poTableViewHeaderH-35, 0, 0, 0);
    }
    [self.view setBackgroundColor: [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]]] ;
    _tableView = tableView;
    
    //     self.view = tableView;
    [self.view addSubview:_tableView];

    _allGroups = [NSMutableArray array] ;
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    _userId = [[defaults objectForKey:@"dic"] objectForKey:@"id"];

    _jifen = [ NSString stringWithFormat:@"%@",[[defaults objectForKey:@"dic"] objectForKey:@"jifen"] ];
   
 //积分可兑换项
    [self loadNewTopics];
//个人积分查询
    
}
-(void)loadjifen
{
    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    dic[@"userId"] = _userId;
//    
//    [[HTTPManager shareManager]  getPath:userInfoUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSError *error = nil;
//        
//        NSData *jsonData = responseObject;
//        
//        if ([jsonData length]>0 && error == nil) {
//            
//            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//            NSArray *detailNSArray = (NSArray *)jsonObj;
//            //字典数组转模型数组
//            
//            _jifen =  [detailNSArray[0] objectForKey:@"jifen"];
//        }
//        
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"ss");
//        
//    }];
    

}
- (void)loadNewTopics
{
        [[HTTPManager shareManager]  getPath:giftListUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
            
            NSData *jsonData = responseObject;
            
            if ([jsonData length]>0 && error == nil) {
                
                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
                NSArray *detailNSArray = (NSArray *)jsonObj;
                //字典数组转模型数组
                for (duihuanModel *ary  in  detailNSArray) {
                    //                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                    [_allGroups addObject:ary];
                }
                
                [self.tableView reloadData];

            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ss");
            
        }];

}

#pragma mark - 数据源
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    header *h= [header header];
    
    [h lipin:_userId];
    
    return h;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100*KWidth_Scale;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  _allGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1 创建可重用的自定义的cell
    
    huanCell *cell = [huanCell shoucangCellWithTabView:tableView];
    //2 设置cell内部的子控件
    
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.duihaun = [duihuanModel mj_objectWithKeyValues:sc];
    
    //返回
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
    NSLog(@"11");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
         NSDictionary *sc = _allGroups[indexPath.row];
        _dhjifen =  [duihuanModel mj_objectWithKeyValues:sc];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
        dic[@"userId"] = [NSString stringWithFormat:@"%@", _userId];
        dic[@"giftId"] = _dhjifen.id;
    
    
       NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
       NSTimeInterval aa=[dat timeIntervalSince1970]*1000;  //  *1000 是精确到毫秒，不乘就是精确到秒
       NSString *timeSp = [NSString stringWithFormat:@"%.0f", aa]; //转为字符型

        dic[@"exchangeTime"] = timeSp;
    
        [[HTTPManager shareManager]  getPath:exchangeGiftUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSError *error = nil;
//         [MBProgressHUD showMessage:@"正在兑换...."];
            NSData *jsonData = responseObject;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *dic = (NSDictionary *)jsonObj;
            
            if (dic != nil && error == nil) {
    
                if(![[dic allKeys] containsObject:@"status"])
                {
                    [MBProgressHUD hideHUD];
                    [MBProgressHUD showError:[dic objectForKey:@"result"]];
                }
                else
                {
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    
                    UIViewController *duihuan = [story instantiateViewControllerWithIdentifier:@"duihuanStory"];
                    
                    [self.navigationController pushViewController:duihuan animated:YES];
                    
                    [_allGroups removeAllObjects];
                    
                    [self loadNewTopics];
                }

//                NSNotification *notification = [NSNotification notificationWithName:@"duihuan" object:nil userInfo:_userId];
//                
//                [[NSNotificationCenter defaultCenter] postNotification:notification];
                

                [self.tableView reloadData];
                
            }

    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ss");
            
        }];

}

- (IBAction)zijiBtn:(id)sender {
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *duihuan = [story instantiateViewControllerWithIdentifier:@"duihuanStory"];
    
    [self.navigationController pushViewController:duihuan animated:YES];
    

}
@end
