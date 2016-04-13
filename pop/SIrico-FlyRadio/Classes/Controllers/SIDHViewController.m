//
//  SIDHViewController.m
//  SIrico-FlyRadio
//
//  Created by Jin on 8/10/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import "SIDHViewController.h"
#import "MyPageLoadingView.h"
#import "SILPEntity.h"
#import "SILPCell.h"

@interface SIDHViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *listView;
@property (nonatomic, strong) NSMutableArray *allData;
@property (nonatomic, strong) MyPageLoadingView *loadingView;

- (void)p_refreshData;
- (void)p_requestJPData:(NSString *)uid;
- (void)p_configView;

@end

@implementation SIDHViewController

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
    
    [self showTopMenuWithStyle:KTopMenuStylePop withTitle:@"积分兑换"];
    _allData = [NSMutableArray array];
    
    [self p_refreshData];
    
}

- (void)p_refreshData
{
    _loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:_loadingView];

    [self p_requestJPData:@""];
}

#pragma mark - request data
- (void)p_requestJPData:(NSString *)uid
{
    [[HTTPManager shareManager] getPath:GET_LIPIN_URL parameters:@{@"sbnumber":@"APP23000018"}  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_loadingView stopLoadingAndDisappear];
        
        NSError *error = nil;
        NSData *adData = [[XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObj = [NSJSONSerialization JSONObjectWithData:adData options:NSJSONReadingAllowFragments error:nil];
        //DBLog(@"jsonobj=%@",jsonObj);
        if ([jsonObj isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *data in jsonObj) {
                SILPEntity *item = [[SILPEntity alloc] initWithData:data];
                [_allData addObject:item];
                item = nil;
            }
        }
        
        [self p_configView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_loadingView stopLoadingAndDisappear];
 
    }];
}

#pragma mark - config view
- (void)p_configView
{
    _listView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    _listView.backgroundColor = CLEAR_COLOR;
    _listView.separatorColor = [UIColor blackColor];
    _listView.dataSource = self;
    _listView.delegate = self;
    [self.view addSubview:_listView];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


- (SILPCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    SILPCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[SILPCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    // Configure the cell...
    
    [cell configCell:_allData[indexPath.row]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.view addSubview:_loadingView];
    
    [self requestDuiHuan:_allData[indexPath.row]];
}

#pragma mark - dui huan
- (void)requestDuiHuan:(SILPEntity *)item
{
    NSString *lpid = item.lpid;
    DBLog(@"pid===%@",lpid);
    [[HTTPManager shareManager] getPath:GET_DHLP_URL parameters:@{@"sbnumber":@"APP23000018",@"lpid":lpid} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_loadingView stopLoadingAndDisappear];
        
        NSError *error = nil;
        
        NSString *result = [XMLReader dictionaryForXMLData:responseObject error:&error][@"string"][@"text"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [_loadingView stopLoadingAndDisappear];
        
    }];
}


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
