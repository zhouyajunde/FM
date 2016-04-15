//
//  ZYJTimeViewController.m
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJTimeViewController.h"
#import "ZYJyinzhisettingde.h"


@implementation ZYJTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSectionItems];
}

-(void)addSectionItems{
   
    ZYJyinzhisettingde *yinzhi = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"取消定时关闭"];
    
    ZYJyinzhisettingde *wifi = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"10分钟"];
    
    ZYJyinzhisettingde *houtai = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"20分钟"];
    ZYJyinzhisettingde *two = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"30分钟"];
    
    ZYJyinzhisettingde *tree = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"60分钟"];
    
    ZYJyinzhisettingde *three = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"90分钟"];
    ZYJyinzhisettingde *five = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"120分钟"];
    
    ZYJyinzhisettingde *liu = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"节目播放完毕后自动关闭"];
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[yinzhi, wifi, houtai,two, tree, three,five, liu]];
    [_allGroups addObject:group];

    
}


@end
