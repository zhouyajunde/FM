//
//  ZYJyinzhiSetting.m
//  飞扬FM
//
//  Created by Mac os on 16/1/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "ZYJyinzhiSetting.h"
#import "ZYJyinzhisettingde.h"


@implementation ZYJyinzhiSetting
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addSectionItems];
}

-(void)addSectionItems{

    ZYJyinzhisettingde *yinzhi = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"智能模式"];
    yinzhi.showVCClass = [ZYJyinzhiSetting class];
    //    yinzhi.operation = ^{
    //
    //    };
    
    ZYJyinzhisettingde *wifi = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"流量模式"];
    //    wifi.operation = ^{
    //
    //    };
    
    ZYJyinzhisettingde *houtai = [ZYJyinzhisettingde itemWithsubtitle:@"" title:@"高质量模式"];
    //    houtai.operation = ^{
    //
    //    };
    
    ZYJShowGroup *group = [ZYJShowGroup groupWithItems:@[yinzhi, wifi, houtai]];
    [_allGroups addObject:group];
    
}

@end
