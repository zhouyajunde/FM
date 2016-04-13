//
//  SIAreaListViewController.m
//  SIrico-FlyRadio
//
//  Created by bjsmit01 on 14-3-25.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import "SIAreaListViewController.h"
#import "SIAreaEntity.h"
#import "SIChannelListViewController.h"
#import "SIDBManger.h"

@interface SIAreaListViewController ()
@property (nonatomic, assign)ChannelType type;
@end

@implementation SIAreaListViewController


- (id)initWithChannelType:(ChannelType)type
{
    if (self = [super init]) {
        self.type = type;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super showTopMenuWithStyle:kTopMenuStyleGoBack withTitle:@"地区列表"];
    
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height - (44 + StatusBarHeight + 10)) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [myTableView setSeparatorColor:[UIColor clearColor]];
    myTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:myTableView];
    
    dataArray = [[NSMutableArray alloc]init];
    
    [self refreshData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) refreshData{
    loadingView = [[MyPageLoadingView alloc]initWithRect:CGRectMake(0, 44+StatusBarHeight, 320, self.view.bounds.size.height - 44-StatusBarHeight)];
    [self.view addSubview:loadingView];
    
    [self getListData];
}

#pragma mark - get list data
- (void)getListData
{
    if (self.type == ChannelType_Internal) {
        dataArray = [[SIDBManger shareManger] getAllArea];
        [myTableView reloadData];
        [loadingView stopLoadingAndDisappear];

    }else{
    
        //TODO: 国外地区列表。
    
    }

    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier=@"CellIdentifier";
    
    UITableViewCell * cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSUInteger row = [indexPath row];
    if(cell == nil){
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
     	cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView * selectColorView = [[UIView alloc]init];
        [selectColorView setBackgroundColor:[UIColor clearColor]];
        [cell setSelectedBackgroundView:selectColorView];
        
        UIImageView * bgView = [[UIImageView alloc]init];
        bgView.image = [UIImage imageNamed:@"fy_play_statue_bg.png"];
        bgView.frame = CGRectMake(5, 0, 310, 48);
        bgView.backgroundColor = [UIColor clearColor];
        [cell.contentView  addSubview:bgView];
        
        
        UILabel * titleLabel1 = [[UILabel alloc]init];
        titleLabel1.frame = CGRectMake(10, 9, 195, 30);
        titleLabel1.backgroundColor = [UIColor clearColor];
        titleLabel1.textColor = [UIColor whiteColor];
        titleLabel1.font = [UIFont systemFontOfSize:15];
        titleLabel1.numberOfLines = 0;
        titleLabel1.tag = 10000;
        titleLabel1.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:titleLabel1];
        
        
        UIButton * playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(262, 0, 48, 48);
        [playButton setImage:[UIImage imageNamed:@"fy_channelplay_radio.png"] forState:UIControlStateNormal];
        playButton.tag = 10001 + indexPath.row;
        [playButton addTarget:self action:@selector(playRadioActon:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:playButton];
      
            
    }
    
    SIAreaEntity * object = [dataArray objectAtIndex:row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:10000];
    nameLabel.text = object.areaName;

    
    
 	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cid = [dataArray[indexPath.row] areaID];
    DBLog(@"cid=%@",cid);
    
    SIChannelListViewController *listController = [[SIChannelListViewController alloc] initWithTidOrAid:cid channelType:ChannelType_AreaChannel];
    [self.navigationController pushViewController:listController animated:YES];
    
}


- (void)playRadioActon:(UIButton *)sender
{

    
    //TODO:分类讨论，地区则继续推向自己。 电台则推向播放器。
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"flag======%d",flag);
    if (flag ==1) {
        [self showPlayer];
    }else{
        [self hidePlayer];
    }
}



#pragma mark - show Player
- (void)showPlayer
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        [[FMPlayer shareManager] changeFrame:Big_Frame];
    }else{
        [[FMPlayer shareManager] changeFrame:Big_FrameForiOS6];
    }
    
    [self.view addSubview:[FMPlayer shareManager]];
    
    myTableView.frame = CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height- (44 + StatusBarHeight + 10) - 70);
}


- (void)hidePlayer
{
    [[FMPlayer shareManager] changeFrame:Small_Frame];
    
    //[self.view addSubview:[FMPlayer shareManager]];
    [[FMPlayer shareManager] removeFromSuperview];
    
    myTableView.frame = CGRectMake(0, 44 + StatusBarHeight + 10, 320, self.view.frame.size.height - (44 + StatusBarHeight + 10));
    
}

@end
