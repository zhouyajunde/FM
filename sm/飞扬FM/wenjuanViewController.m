//
//  wenjuanViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "wenjuanViewController.h"
#import "UserDefine.h"
#import "HTTPManager.h"
#import "MBProgressHUD+NJ.h"

@interface wenjuanViewController ()
{
    NSString *_userId;
}
@end

@implementation wenjuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arry = [NSMutableArray new];
    
    
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    _userId = [[defaults objectForKey:@"dic"] objectForKey:@"id"];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tuijian_bg.png"]];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.frame = CGRectMake(0, 64, 320, [UIScreen mainScreen].bounds.size.height*420/568);
    scrollView.pagingEnabled = NO;
    scrollView.bouncesZoom = YES;
    scrollView.delaysContentTouches = NO;
    scrollView.canCancelContentTouches = YES;
    scrollView.delegate = self;
    scrollView.userInteractionEnabled = YES;
    [scrollView setShowsVerticalScrollIndicator:YES];
    [scrollView setScrollEnabled:YES];
    //NO 发送滚动的通知 但是就算手指移动 scroll也不会动了 YES 发送通知 scroo可以移动
    [scrollView setCanCancelContentTouches:YES];
    // NO 立即通知touchesShouldBegin:withEvent:inContentView 看是否滚动 scroll
    [scrollView setDelaysContentTouches:NO];

    scrollView.contentSize = CGSizeMake(self.view.frame.size.width,self.view.frame.size.height*930/568);
    [self.view addSubview:scrollView];
    UIButton *Button = [UIButton buttonWithType:UIButtonTypeCustom];
    Button.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*20/320,[UIScreen mainScreen].bounds.size.height*500/568,[UIScreen mainScreen].bounds.size.width*280/320,[UIScreen mainScreen].bounds.size.height*40/568);
    [Button setTitle:@"提交答案" forState:UIControlStateNormal];//设置button的title
    Button.titleLabel.font = [UIFont systemFontOfSize:14];//title字体大小
    Button.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    [Button setBackgroundImage:[UIImage imageNamed:@"login_btn.png"] forState:UIControlStateNormal];
    [Button addTarget:self action:@selector(tijiao:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Button];
    
    [self loadListData];

}

-(void)tijiao:(id)sender
{
    NSMutableArray *all = [NSMutableArray new];
    
    if ([item getValue]!=nil && [item1 getValue] != nil && [item2 getValue] != nil &&  [item3 getValuew] != nil) {
        [all addObject:[item getValue]];
        [all addObject:[item1 getValue]];
        [all addObject:[item2 getValue]];
        [all addObject:[item3 getValuew]];
    }

    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:all options:NSJSONWritingPrettyPrinted error: &error];
//    NSMutableData *tempJsonData = [self dictionaryToJson:dic];
//[NSMutableData dataWithData:jsonData];
    NSMutableDictionary *result =[NSMutableDictionary new];
    
    result[@"id"] = _sjid;
    result[@"data"] = all;

    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"pama"] = [self dictionaryToJson:result];
    
//    for (NSDictionary *dic in all) {
//        
//        NSString
//    }
//    
    NSString  *url = [NSString stringWithFormat:@"%@%@", saveRecordURL , _userId];

//    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:url]];
//
////    [client setDefaultHeader:@"Accept" value:@"application/json"];
////    [client setDefaultHeader:@"Content-Type" value:@"application/json; charset=utf-8"];
//    
//    [client postPath:@"" parameters:result success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"POST请求:%@",responseObject);
//    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
    
    [MBProgressHUD showMessage:@"正在提交"];
    
    [[HTTPManager shareManager]  postPath:url parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"提交成功"];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"提交失败"];

        
    }];
    
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
-(void)loadListData {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"papersId"] = _sjid;
    
    [[HTTPManager shareManager] getPath:subjectsListURL parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *detailNSArray = (NSArray *)jsonObj;
            //字典数组转模型数组
            
            for (NSMutableDictionary *dic in detailNSArray) {
                if ([[dic objectForKey:@"subType"]isEqualToString:@"1"]){
                    
                    item = [[danxuanView alloc]initWithFrame:CGRectMake(10,0,300,[UIScreen mainScreen].bounds.size.height*200/568)withTitle:dic];
                    item.backgroundColor = [UIColor redColor];
                    item.delegate = self;
                    [scrollView addSubview:item];
                    
                }else if ([[dic objectForKey:@"subType"]isEqualToString:@"2"]){
                    item1 = [[duoxuanView alloc]initWithFrame:CGRectMake(10,210,300,[UIScreen mainScreen].bounds.size.height*200/568)];
                    [item1 withTitle:dic];
                    item.backgroundColor = [UIColor clearColor];
                    
                    [scrollView addSubview:item1];
                    
                }else if ([[dic objectForKey:@"subType"]isEqualToString:@"3"]){
                    item2 = [[wendaView alloc]initWithFrame:CGRectMake(10,420,300,[UIScreen mainScreen].bounds.size.height*200/568)withTitle:dic];
                    item2.backgroundColor = [UIColor clearColor];
                    
                    [scrollView addSubview:item2];
                    
                }else{
                    item3 = [[wendaView alloc]initWithFrame1:CGRectMake(10,630,300,[UIScreen mainScreen].bounds.size.height*200/568)withTitle:dic];
                    item3.backgroundColor = [UIColor clearColor];
                    
                    [scrollView addSubview:item3];
                }

            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];

    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
}


@end
