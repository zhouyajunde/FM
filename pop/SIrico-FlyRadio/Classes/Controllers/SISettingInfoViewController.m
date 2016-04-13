//
//  SISettingInfoViewController.m
//  SIrico-FlyRadio
//
//  Created by Ruixin yu on 14-3-29.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SISettingInfoViewController.h"

@interface SISettingInfoViewController ()

@end

@implementation SISettingInfoViewController
@synthesize type;

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
    [self showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:@""];
    
    
    [self refreshData];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshData
{
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44 + StatusBarHeight, 320, self.view.frame.size.height-44 - StatusBarHeight)];
    [self.view addSubview:loadingView];
    
    if (self.type == 74004) {
        [self getTermsData];
        [self resetTopMenuTitle:@"使用条款"];
    }else if (self.type == 74005){
        [self getAboutData];
        [self resetTopMenuTitle:@"关于我们"];

    }
    

}

- (void)getAboutData
{
    [[HTTPManager shareManager] postPath:Get_ABOUT_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:&error];
        DBLog(@"dic+++++++++%@",dic);
        description = [[dic objectForKey:@"string"] objectForKey:@"text"];
        DBLog(@"s++++++++%@",description);
        
        
        [self reloadDataFromDB];
        [loadingView stopLoadingAndDisappear];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadingView stopLoadingAndDisappear];
    }];


}



- (void)getTermsData
{
    [[HTTPManager shareManager] postPath:Get_TERMS_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSDictionary *dic = [XMLReader dictionaryForXMLData:responseObject error:&error];
        DBLog(@"dic+++++++++%@",dic);
        description = [[dic objectForKey:@"string"] objectForKey:@"text"];
        DBLog(@"s++++++++%@",description);
        
        
        [self reloadDataFromDB];
        [loadingView stopLoadingAndDisappear];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [loadingView stopLoadingAndDisappear];
    }];
}

- (void)reloadDataFromDB
{
   
    UIView *topMenuView = [super getTopMenuView];
    
    UIScrollView * bGView = [[UIScrollView alloc]init];
    bGView.frame = CGRectMake(10, StatusBarHeight, 300, self.view.frame.size.height);
    bGView.showsVerticalScrollIndicator = NO;
    [self.view insertSubview:bGView belowSubview:topMenuView];
    
    float descY = 44 + 5;
    
    UILabel *descLabel1 = [[UILabel alloc]init];
    NSString * descriptionString = description;
    if(!descriptionString || descriptionString.length <1){
        descriptionString = @"暂无";
    }
    
    descLabel1.frame = CGRectMake(0, descY, 300, self.view.frame.size.height - 55);
    descLabel1.text = descriptionString;
    descLabel1.textAlignment = NSTextAlignmentLeft;
    descLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    descLabel1.numberOfLines = 0;
    [descLabel1 setBackgroundColor:[UIColor clearColor]];
    descLabel1.font = [UIFont systemFontOfSize:13];
    [descLabel1 setTextColor:[UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:0.7]];
    [bGView addSubview:descLabel1];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle.copy};
   CGSize labelSize = [descriptionString boundingRectWithSize:CGSizeMake(299, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    NSLog(@"labelSize.h:::%f\n labelSize.w::%f",labelSize.height,labelSize.width);
    
    
//    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
//    [ps setAlignment:NSTextAlignmentRight];
//    [ps setLineBreakMode:NSLineBreakByCharWrapping];
//    
//    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:ps,NSParagraphStyleAttributeName,nil];
    
    [descLabel1 setFrame:CGRectMake(0, descY, labelSize.width, labelSize.height)];
    
    //计算内容的大小
    float contentWidth = 300;
    float contentHeight = descLabel1.frame.origin.y + descLabel1.frame.size.height + 30;
    if (contentHeight <= bGView.frame.size.height) {
        contentHeight = bGView.frame.size.height + 5;
    }
    
    bGView.contentSize = CGSizeMake(contentWidth, contentHeight);



}


@end
