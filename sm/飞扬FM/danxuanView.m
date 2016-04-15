//
//  danxuanView.m
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import "danxuanView.h"

@implementation danxuanView

- (id)initWithFrame:(CGRect)frame withTitle:(NSMutableDictionary *)data
{
    timu = data;
    btns =  [NSMutableArray new];

    self = [super initWithFrame:frame];
    if (self) {
        
                 title  = [[UILabel alloc]initWithFrame:CGRectMake(10,0,frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        
        NSString *P = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"name"],@"*"];
        title.text = P;
        title.tag = [[data objectForKey:@"id"]longLongValue];
        title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
        
      
       NSMutableArray  *chooses = (NSMutableArray *)[data objectForKey:@"chooses"];
       
        valdic = [NSMutableDictionary dictionary];
        
        
        for (int i = 0; i < chooses.count; i++) {
            title  = [[UILabel alloc]initWithFrame:CGRectMake(20,(i+1)*40,frame.size.width, 30)];
            title.backgroundColor = [UIColor clearColor];
            
            NSString *s = [NSString stringWithFormat:@"%d%@",i+1,@"."];
            
            NSString *ST= [NSString stringWithFormat:@"%@%@",s,[[[data objectForKey:@"chooses"][i] objectForKey:@"name"]description]];
            
            [ary addObject:[[data objectForKey:@"chooses"][i] objectForKey:@"name"]];
//            title.tag = [[([data objectForKey:@"chooses"][i]) objectForKey:@"id"] longLongValue];
            title.text = ST;
            title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
            title.textColor = [UIColor whiteColor];
            [self addSubview:title];
           
            btn = [[UIButton alloc]initWithFrame:CGRectMake(260,(i+1)*40 + 5,20, 20)];
            
            
            NSMutableDictionary *temp =[NSMutableDictionary new];
            
            [temp setObject:[[data objectForKey:@"chooses"][i] objectForKey:@"id"] forKey:@"id"];
            [temp setObject:[[data objectForKey:@"chooses"][i] objectForKey:@"name"] forKey:@"value"];
//            [temp setObject: @"DAAS"forKey:@"value"];


            btn.tag = temp;
            
            valdic = temp;
            
            [arrry addObject:[[data objectForKey:@"chooses"][i] objectForKey:@"id"]];
            [btn setImage:[UIImage imageNamed:@"food_select"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"food_selected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
  return self;
    
}

-(void)btn:(UIButton *)button{
    
    if(button!= btn){
        btn.selected=NO;
        btn=button;
    }
    btn.selected=YES;
    
    [self getValue];
}

- (NSMutableDictionary *) getValue{
    
    NSMutableDictionary *result =[NSMutableDictionary new];
    
    [result setObject:@"1" forKey:@"type"];
    
    [result setObject:[timu objectForKey:@"id"] forKey:@"id"];
    
    NSMutableDictionary   *selecteds = [NSMutableDictionary new];

    [result setObject:valdic forKey:@"value"];
    
    
    return result;
};


@end
