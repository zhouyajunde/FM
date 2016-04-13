//
//  SIUserInfoViewController.m
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIUserInfoViewController.h"
#import "SIUserInfo.h"
#import "SIJFHeaderView.h"
#import "SIDHJLEntity.h"
#import "SIJLCell.h"
#import "MyPageLoadingView.h"

@interface SIUserInfoViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) SIJFHeaderView *headerView;
@property (nonatomic, strong) SIUserInfo *userInfo;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) MyPageLoadingView *loadingView;

-(void)p_requestUserInfo:(NSString *)userid;
-(void)p_rquestDHJL:(NSString *)userid;
@end

@implementation SIUserInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //nav
    [self showTopMenuWithStyle:KTopMenuStylePop withTitle:@"我的信息"];
    [self refreshData];
    
    [self p_requestUserInfo:@""];
    
    _allData = [NSMutableArray array];

    //[self configView];
    
    
}

- (void)refreshData
{
    _loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:_loadingView];

}

#pragma mark - get data
-(void)p_requestUserInfo:(NSString *)userid
{
    
    [[HTTPManager shareManager] getPath:Get_USERINFO_URL parameters:@{@"sbnumber":@"APP23000018"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        //DBLog(@"jsonobj=%@",jsonObj);
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            _userInfo = [SIUserInfo new];
            for (NSDictionary *data in jsonObj) {
                _userInfo.userAddTime = data[@"addtime"];
                _userInfo.userAge = data[@"age"];
                _userInfo.userEdu = data[@"edu"];
                _userInfo.userJF = data[@"jifen"];
                _userInfo.userMoney = data[@"money"];
                _userInfo.userSex = data[@"sex"];
                _userInfo.userName = data[@"username"];
            }
            
            [self p_rquestDHJL:@""];
            
        }else{
            
            
        }
        
        //[self configView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        DBLog(@"error==%@",error.localizedDescription);
    }];
}

- (void)p_rquestDHJL:(NSString *)userid
{
    [[HTTPManager shareManager] getPath:GET_DHJL_URL parameters:@{@"sbnumber":@"APP23000018"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        //DBLog(@"jsonobj=%@",jsonObj);
        
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *data in jsonObj) {
                SIDHJLEntity *item = [[SIDHJLEntity alloc] initWithData:data];
                [_allData addObject:item];
                item = nil;
            }
            
        }else{
            
            
        }

        [_loadingView stopLoadingAndDisappear];
        
        [self configView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_loadingView stopLoadingAndDisappear];

    }];
    
}


#pragma mark - config View
- (void)configView
{

    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    _listView.backgroundColor = CLEAR_COLOR;
    _listView.separatorColor = [UIColor blackColor];
    _listView.dataSource = self;
    _listView.delegate = self;
    [self.view addSubview:_listView];
    
    _headerView = [[SIJFHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 160)];
    _headerView.userLabel.text = _userInfo.userName;
    _headerView.ageLabel.text = _userInfo.userAge;
    _headerView.sexLabel.text = _userInfo.userSex;
    _headerView.jobLabel.text = _userInfo.userJob;
    _headerView.moneyLabel.text = _userInfo.userMoney;
    _headerView.eduLabel.text = _userInfo.userEdu;
    _headerView.jfLabel.text = _userInfo.userJF;
    _listView.tableHeaderView = _headerView;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [_allData count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 200;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (SIJLCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    SIJLCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SIJLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    [cell configCell:_allData[indexPath.row]];
    
    return cell;
}

//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
