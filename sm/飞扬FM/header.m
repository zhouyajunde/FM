//
//  header.m
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import "header.h"
#import "HTTPManager.h"
#import "UserDefine.h"

@interface header ()

@end

@implementation header

+(instancetype)header;
{
     return [[NSBundle mainBundle] loadNibNamed:@"header" owner:nil options:nil][0];
    
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(kais:) name:@"duihuan" object:nil];
    }
    return self;
}

-(void)lipin:(NSString *)pin
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    dic[@"userId"] = [NSString stringWithFormat:@"%@", pin];
    
    [[HTTPManager shareManager]  getPath:userInfoUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            NSArray *detailNSArray = (NSArray *)jsonObj;
            //字典数组转模型数组
            

            
            _jifenLab.text =  [NSString stringWithFormat:@"%@",[detailNSArray[0] objectForKey:@"jifen"]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"ss");
        
    }];

}

//-(void)kais:(NSNotification *)test
//{
//    
//        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//        dic[@"userId"] = [NSString stringWithFormat:@"%@", test.userInfo];
//    
//        [[HTTPManager shareManager]  getPath:userInfoUrl parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSError *error = nil;
//    
//            NSData *jsonData = responseObject;
//    
//            if ([jsonData length]>0 && error == nil) {
//    
//                id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//                NSArray *detailNSArray = (NSArray *)jsonObj;
//                //字典数组转模型数组
//    
//                _jifenLab.text =  [detailNSArray[0] objectForKey:@"jifen"];
//            }
//    
//    
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            
//            NSLog(@"ss");
//            
//        }];
//
//}

@end
