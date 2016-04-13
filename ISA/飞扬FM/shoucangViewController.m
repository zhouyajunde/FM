//
//  shoucangViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "shoucangViewController.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "scModel.h"
#import "MJExtension.h"
#import "UIScrollView+MJRefresh.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "ZYJdic.h"
#import "bianjiView.h"

@interface shoucangViewController ()<editDetegate>{
    UITableViewCellEditingStyle editingStyle;
    BOOL a;
    bianjiView *_bianji;
    
    NSString *_useId;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *edit;
- (IBAction)editBtn:(id)sender;

@property (nonatomic, weak) HTTPManager *mgr;
@property (nonatomic, strong) NSMutableArray *topics;
@property (nonatomic, strong) NSMutableArray *apps;
@property(nonatomic,strong)ZYJdic *ZYJdic;
@end


@implementation shoucangViewController


#pragma mark - 懒加载
- (IBAction)editBtn:(id)sender {
    
    if (self.tableView.editing) {
        
        [self.tableView setEditing:NO animated:YES];
        _edit.title = @"编辑";
        
        self.tabBarController.tabBar.hidden = NO;
    }else
    {
       
        [self.tableView setEditing:YES animated:YES];
          editingStyle = UITableViewCellEditingStyleDelete;
        _edit.title = @"完成";
        
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (HTTPManager *)mgr
{
    if (!_mgr) {
        _mgr = [HTTPManager shareManager];
    }
    return _mgr;
}

-(void)viewWillAppear:(BOOL)animated
{
       self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    
    _useId = [ NSString stringWithFormat:@"%@", [_dic objectForKey:@"id"]];

    
    //网络请求
    [self loadDate];
    
    // 集成刷新控件
    [self setUpRefresh];
    
    _bianji = [bianjiView init];
    
    _bianji.frame = CGRectMake(0, 520, self.view.frame.size.width,  30);
    _bianji.delegate = self;
    
    [self.view addSubview:_bianji];
}

/**
 * 集成刷新控件
 */
- (void)setUpRefresh
{
    self.tableView.mj_header = [BSHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    [self.tableView.mj_header beginRefreshing];
    
//    self.tableView.mj_footer = [BSFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

- (void)loadNewTopics
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = _useId;
    
    [self.mgr getPath:shoucangListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *detailNSArray = (NSArray *)jsonObj;
            //字典数组转模型数组
            
            if (_allGroups.count == 0) {

            for (scModel *ary  in  detailNSArray) {
                self.topics = [scModel mj_objectArrayWithKeyValuesArray:ary];
                [_allGroups addObject:ary];
            }
            
            [self.tableView reloadData];
 
        }
            [self.tableView.mj_header endRefreshing];

    }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [self.tableView.mj_header endRefreshing];

        
    }];
    
}

- (void)loadMoreTopics
{
    // 取消之前的请求
//    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    [self.tableView.mj_footer endRefreshing];

}

-(void)loadDate{
   
}

-(void)all
{
    if (!a) {
        
        _bianji.labText.text = @"取消";
        for (int row = 0 ; row < _allGroups.count; row++ ){
            NSIndexPath *indexPatht = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView selectRowAtIndexPath:indexPatht
                                        animated:YES
                                  scrollPosition:UITableViewScrollPositionNone];
            
        }
        
        for (scModel *mode in [scModel mj_objectArrayWithKeyValuesArray:_allGroups]) {
            
             [_editArray addObject:[NSString stringWithFormat:@"%@",mode.id]];
        }
        
        a = YES;

    }else{
         _bianji.labText.text = @"全选";
        for (int row = 0 ; row < _allGroups.count; row++){
            NSIndexPath *indexPatht = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView deselectRowAtIndexPath:indexPatht
                                     animated:YES];
        }
        
        [_editArray removeAllObjects];
        a = NO;
    }
    
}
-(void)deleteEdit
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"userId"] = _useId;
    
    NSString *string = [NSString new];
    
    for (NSString *f in _editArray) {
        
        string = [NSString stringWithFormat:@"%@,%@",f,string];
    }
    
    parameters[@"channelIds"] = string;
    
    [self.mgr postPath:removeshoucangURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
          
             [_editArray removeAllObjects];
             [_allGroups removeAllObjects];
             [self.tableView setEditing:NO animated:YES];
             [self.tableView.mj_header beginRefreshing];
             _edit.title = @"编辑";
             self.tabBarController.tabBar.hidden = NO;
             [self loadDate];
             [self.tableView reloadData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        [self.tableView setEditing:NO animated:YES];
        [self.tableView.mj_header beginRefreshing];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
      self.tabBarController.tabBar.hidden = NO;
}

@end
