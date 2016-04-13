//
//  turnImg.m
//  飞扬FM
//
//  Created by Mac os on 15/12/31.
//  Copyright © 2015年 Mac os. All rights reserved.
//

#import "turnImg.h"
#import "HTTPManager.h"
#import "UserDefine.h"
#import "Statics.h"

@implementation turnImg

+(NSMutableArray *)initImg{
    
    NSMutableArray *img = [[NSMutableArray alloc]init];
  
    
    [[HTTPManager shareManager] postPath:imgsixURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        
        NSData *jsonData = responseObject;
        
        if ([jsonData length]>0 && error == nil) {
            error = nil;
            
            id jsonObj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

            if (jsonObj != nil && error == nil) {
                //如果jsonObject是字典类
                if ([jsonObj isKindOfClass:[NSDictionary class]]){
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObj;
                    NSLog(@"Dersialized JSON Dictionary = %@", deserializedDictionary);
                }else if ([jsonObj isKindOfClass:[NSArray class]]){
                    NSArray *deserializedArray = (NSArray *)jsonObj;
                    NSLog(@"Dersialized JSON Array = %@", deserializedArray);
                    
                    for (NSDictionary *data in deserializedArray){
                        [img addObject:[data objectForKey:@"url"]];
                        
                        NSLog(@"-----%@",img);
                    }
                }
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
        NSLog(@"",error);
//        DBError(error);
        
    }];

    return img;
}
@end
