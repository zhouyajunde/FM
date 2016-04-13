//
//  ZYJduihuanViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJduihuanViewController.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "MJExtension.h"
#import "huanModel.h"
#import "duihuanCell.h"
#import "MBProgressHUD+NJ.h"

//相对iphone6 屏幕比
#define KWidth_Scale    [UIScreen mainScreen].bounds.size.width/375.0f

const int   duiTableViewHeaderH = 35;


@interface ZYJduihuanViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString *_userId,*_jifen;
    huanModel *_dhjifen;
}

- (IBAction)jilu:(id)sender;

@end

@implementation ZYJduihuanViewController

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg"]];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    // 设置背景
    tableView.backgroundView = nil;
    tableView.backgroundColor = [UIColor clearColor];
    // 分隔线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.sectionFooterHeight = 0;
    tableView.sectionHeaderHeight = duiTableViewHeaderH;
    
    if (iOS7) {
        tableView.contentInset = UIEdgeInsetsMake(duiTableViewHeaderH-35, 0, 0, 0);
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
    
    //积分可兑换项
    [self loadNewTopics];
    //个人积分查询
    //    [self loadjifen];
}

- (void)loadNewTopics
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"userId"] = _userId;
    
    [[HTTPManager shareManager]  getPath:exchangeListUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *detailNSArray = (NSArray *)jsonObj;
            //字典数组转模型数组
            for (huanModel *ary  in  detailNSArray) {
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
    
    duihuanCell *cell = [duihuanCell shoucangCellWithTabView:tableView];
    //2 设置cell内部的子控件
    
    NSDictionary *sc = _allGroups[indexPath.row];
    
    cell.duihaun = [huanModel mj_objectWithKeyValues:sc];
    
    //返回
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除选中时的背景
    NSLog(@"11");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
