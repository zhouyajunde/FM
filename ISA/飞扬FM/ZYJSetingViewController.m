//
//  ZYJSetingViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJSetingViewController.h"
#import "ZYJpersonMessage.h"
#import "ZYJSettingSwitchItem.h"
#import "NJSettingKeys.h"
#import "NSObject+FileManager.h"
#import "SDImageCache.h"
#import "MBProgressHUD+NJ.h"
#import "ZYJyinzhisettingde.h"
#import "ZYJyinzhiSetting.h"
#import "ZYJchangjian.h"
#import "ZYJyijian.h"
#import "ZYJguanyu.h"


@implementation ZYJSetingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self addSectionItems];
    
    [self add0SectionItems];
    
    [self add1SectionItems];
    
    [self add2SectionItems];
}

-(void)addSectionItems{
    
    ZYJShowArrowitem *yinzhi = [ZYJShowArrowitem itemWithTitle:@"音质设置"];
    yinzhi.showVCClass = [ZYJyinzhiSetting class];
    
    ZYJSettingSwitchItem *wifi = [ZYJSettingSwitchItem itemWithTitle:@"在非wifi下播放"];
    wifi.key = NJSettingShakeChoose;
    
    ZYJSettingSwitchItem *houtai = [ZYJSettingSwitchItem itemWithTitle:@"后台播放"];
    houtai.key = NJSettingShakeChoose;

    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[yinzhi, wifi, houtai]];
    [_allGroups addObject:group];

}

- (void)add0SectionItems
{
    ZYJpersonMessage *qingchu = [ZYJpersonMessage itemWithsubtitle:[NSString stringWithFormat:@"%.1fM",[self filePath]] title:@"清除缓存"];
    
    qingchu.operation = ^{
        
          [self clearFile];
          [qingchu setSubtitle:@"0.0M"];
        
            [self.tableView reloadData];
//
            [MBProgressHUD showMessage:@"正在清除"];
//
            [MBProgressHUD hideHUD];
//        }];
    };
    
    ZYJSettingSwitchItem *xiaoxi = [ZYJSettingSwitchItem itemWithTitle:@"消息推送"];
    xiaoxi.key = NJSettingShakeChoose;

    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[qingchu, xiaoxi]];
    [_allGroups addObject:group];
}

#pragma mark 添加第1组的模型数据
- (void)add1SectionItems
{
    ZYJShowArrowitem *yinzhi = [ZYJShowArrowitem itemWithTitle:@"常见问题"];
    yinzhi.showVCClass = [ZYJchangjian class];
    
    ZYJShowArrowitem *wifi = [ZYJShowArrowitem itemWithTitle:@"意见反馈"];
    wifi.showVCClass = [ZYJyijian class];
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[yinzhi, wifi]];
    [_allGroups addObject:group];

}
-(void)add2SectionItems{
    ZYJShowArrowitem *houtai = [ZYJShowArrowitem itemWithTitle:@"关于飞扬FM"];
    houtai.showVCClass = [ZYJguanyu class];
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[houtai]];
    [_allGroups addObject:group];

}


//*********************清理缓存********************//
// 显示缓存大小
-( float )filePath
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    return [ self folderSizeAtPath :cachPath];
    
}
//1:首先我们计算一下 单个文件的大小

- ( long long ) fileSizeAtPath:( NSString *) filePath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if ([manager fileExistsAtPath :filePath]){
        
        return [[manager attributesOfItemAtPath :filePath error : nil ] fileSize ];
    }
    
    return 0 ;
    
}
//2:遍历文件夹获得文件夹大小，返回多少 M（提示：你可以在工程界设置（)m）

- ( float ) folderSizeAtPath:( NSString *) folderPath{
    
    NSFileManager * manager = [ NSFileManager defaultManager ];
    
    if (![manager fileExistsAtPath :folderPath]) return 0 ;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath :folderPath] objectEnumerator ];
    
    NSString * fileName;
    
    long long folderSize = 0 ;
    
    while ((fileName = [childFilesEnumerator nextObject ]) != nil ){
        
        NSString * fileAbsolutePath = [folderPath stringByAppendingPathComponent :fileName];
        
        folderSize += [ self fileSizeAtPath :fileAbsolutePath];
        
    }
    
    return folderSize/( 1024.0 * 1024.0 );
    
}
// 清理缓存

- (void)clearFile
{
    
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    
    NSArray * files = [[ NSFileManager defaultManager ] subpathsAtPath :cachPath];
    
    NSLog ( @"cachpath = %@" , cachPath);
    
    for ( NSString * p in files) {
        
        NSError * error = nil ;
        
        NSString * path = [cachPath stringByAppendingPathComponent :p];
        
        if ([[ NSFileManager defaultManager ] fileExistsAtPath :path]) {
            
            [[ NSFileManager defaultManager ] removeItemAtPath :path error :&error];
            
        }
        
    }
    
    [ self performSelectorOnMainThread : @selector (clearCachSuccess) withObject : nil waitUntilDone : YES ];
    
}

- (void)clearCachSuccess
{
    
    NSLog ( @" 清理成功 " );
    
    //    NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];//刷新
    //    [UITableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


@end
