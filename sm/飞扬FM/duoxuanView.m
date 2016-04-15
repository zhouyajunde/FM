//
//  duoxuanView.m
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import "duoxuanView.h"

@implementation duoxuanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

- (void)withTitle:(NSMutableDictionary *)data
{
    timu = data;
    title  = [[UILabel alloc]initWithFrame:CGRectMake(10,0,self.frame.size.width, 30)];
    title.backgroundColor = [UIColor clearColor];
    NSString *P = [NSString stringWithFormat:@"%@%@",[data objectForKey:@"name"],@"*"];
    title.text = P;
    title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
    title.textColor = [UIColor whiteColor];
    [self addSubview:title];
    
    btns =  [NSMutableArray new];
    
    NSMutableArray  *chooses = (NSMutableArray *)[data objectForKey:@"chooses"];
    
    valdic = [NSMutableDictionary dictionary];
    
    for (int i=0; i<chooses.count; i++) {
        UIButton  *btn = [[UIButton alloc]initWithFrame:CGRectMake(260,(i+1)*40 + 5,20, 20)];
        
        NSMutableDictionary *temp =[NSMutableDictionary new];
        
        [temp setObject:[[data objectForKey:@"chooses"][i] objectForKey:@"id"] forKey:@"id"];
        [temp setObject:[[data objectForKey:@"chooses"][i] objectForKey:@"name"] forKey:@"value"];
        
        btn.tag = temp;
//         [temp setObject: @"DAAS"forKey:@"value"];
        valdic = temp;
        
        
        [btn setImage:[UIImage imageNamed:@"food_select"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"food_selected"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btns addObject:btn];
        
        title  = [[UILabel alloc]initWithFrame:CGRectMake(20,(i+1)*40,self.frame.size.width, 30)];
        title.backgroundColor = [UIColor clearColor];
        
        NSString *s = [NSString stringWithFormat:@"%d%@",i+1,@"."];
        
        NSString *ST= [NSString stringWithFormat:@"%@%@",s,[[[data objectForKey:@"chooses"][i] objectForKey:@"name"]description]];
        title.text = ST;
        title.font = [UIFont fontWithName:@"Helvetica" size:14.f];
        title.textColor = [UIColor whiteColor];
        [self addSubview:title];
    }

}

-(void)btn:(UIButton *)sender{
    if (sender.selected) {
        sender.selected=NO;
    }else{
        sender.selected=YES;
    }
    
    [self getValue];
}

- (NSMutableDictionary *) getValue{
    
    NSMutableDictionary *result =[NSMutableDictionary new];
    
    [result setObject:@"2" forKey:@"type"];
    
    [result setObject:[timu objectForKey:@"id"] forKey:@"id"];
    
    NSMutableArray *selecteds = [NSMutableArray new];
    
    for (int i=0; i<btns.count; i++) {
        UIButton *btn = (UIButton *)btns[i];
        if(btn.selected){
            [selecteds addObject:valdic];
        }
    }
    [result setObject:selecteds forKey:@"value"];
    
    return result;
};

@end
