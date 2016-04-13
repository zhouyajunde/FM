//
//  seacherControllerVC.m
//  searchControllerDemo
//
//  Created by xynet on 15/12/28.
//  Copyright © 2015年 GKH. All rights reserved.
//

#import "seacherControllerVC.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "MMLabel.h"
#import "BSHeader.h"
#import "BSFooter.h"
#import "MJExtension.h"
#import "MBProgressHUD+NJ.h"
#import "seacherJieguo.h"

@interface seacherControllerVC ()<UISearchResultsUpdating,UISearchBarDelegate>
{
    NSString *pagN;
    int times; //记录上拉的次数
}

@property (strong,nonatomic) UITableViewController *searchResultsController;
@property (strong,nonatomic) UISearchController *SearchController;

@property (strong,nonatomic) NSMutableArray *tableArry;//数据
@property (strong,nonatomic) NSMutableArray *searchArry;//搜索后的数据

@property (nonatomic, weak) HTTPManager *mgr;

@end

@implementation seacherControllerVC

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
    [self loadData];
    [self loadTableView];
    [self LoadSearchController];
     self.navigationItem.title=@"搜索";
//    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//    [center addObserver:self selector:@selector() name:UISearchBarIcon object:<#(nullable id)#>];
}
//加载数据
-(void)loadData{
//    self.tableArry=[[NSMutableArray alloc]init];
//    self.searchArry=[[NSMutableArray alloc]init];
//    for (int i=10000; i<99999; i++) {
//        NSString *string=[NSString stringWithFormat:@"%d",i];
//        [self.tableArry addObject:string];
//    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    // 3.主动召唤出键盘
    [self.SearchController.searchBar becomeFirstResponder];
}

//加载表格单元
-(void)loadTableView{
//    self.tableView.tableFooterView=[[UIView alloc]init];
}
//加载搜索框
-(void)LoadSearchController{
    self.searchResultsController=[[UITableViewController alloc]init];//这个控制器可以自己定义
    self.searchResultsController.edgesForExtendedLayout=UIRectEdgeNone;
    self.searchResultsController.tableView.tableFooterView=[[UIView alloc]init];
    self.searchResultsController.tableView.delegate=self;
    self.searchResultsController.tableView.dataSource=self;
    self.searchResultsController.tableView.backgroundColor = [UIColor clearColor];
    self.SearchController=[[UISearchController alloc]initWithSearchResultsController:self.searchResultsController];
    
    self.SearchController.searchResultsUpdater=self;
    self.SearchController.searchBar.frame=CGRectMake(0, 0, self.view.bounds.size.width, 44);
    self.SearchController.searchBar.delegate=self;
    self.SearchController.searchBar.placeholder = @"请输入地址、电台名称、关键字";
    self.SearchController.searchBar.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView=self.SearchController.searchBar;
    
    self.SearchController.active = YES;
    // 设置为NO,可以点击搜索出来的内容
    self.SearchController.dimsBackgroundDuringPresentation = NO;
    
//    [self.SearchController becomeFirstResponder];
}
#pragma mark-- tableView delgate
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {
    view.tintColor = [UIColor clearColor];
}
#pragma searchController delgate
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController;{
    NSString *filterString = searchController.searchBar.text;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [c] %@", filterString];
    self.searchArry = [NSMutableArray arrayWithArray:[self.tableArry filteredArrayUsingPredicate:predicate]];
//    UITableViewController *searchTableController=(UITableViewController *)searchController;
    [self.searchResultsController.tableView reloadData];
}
#pragma mark--searchBar
//点击键盘的搜索
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [MBProgressHUD showMessage:@"正在搜索..."];
    seacherJieguo *jieguo =[[seacherJieguo alloc]init];
    jieguo.name = _SearchController.searchBar.text;
    
    [self.navigationController pushViewController:jieguo animated:YES];
    
    [searchBar resignFirstResponder];
    
}
//点击取消按钮
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"点击取消");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.SearchController.active) {
        self.SearchController.active = NO;
        [self.SearchController.searchBar removeFromSuperview];
    }
}


@end
