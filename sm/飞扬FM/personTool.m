//
//  personTool.m
//  飞扬FM
//
//  Created by Mac os on 16/3/15.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "personTool.h"
#import "MJExtension.h"
#import "ZYJdic.h"

static ZYJdic *_ZYJdic;

@implementation personTool

+(ZYJdic *)person
{
    // 1.获取NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // 2.通过NSUserDefaults获取保存的数据
    
    NSDictionary *_dic = [defaults objectForKey:@"dic"];
    
    //用mj 字典转模型
    _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    return _ZYJdic;
}

+(void)setPerson:(ZYJdic *)peron
{
    if (!_ZYJdic) {
        // 1.获取NSUserDefaults
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        // 2.通过NSUserDefaults获取保存的数据
        
        NSDictionary *_dic = [defaults objectForKey:@"dic"];
        
        //用mj 字典转模型
       _ZYJdic = [ZYJdic mj_objectWithKeyValues:_dic];
    }
}


@end
