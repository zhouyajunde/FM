//
//  danxuanView.h
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol danxuanDelegate <NSObject>

-(void)newmess:(NSDictionary *)dic;

@end


@interface danxuanView : UIView{
    
    
    NSMutableDictionary *timu;
       NSMutableArray *btns;
    UILabel *title ;
    NSMutableDictionary *dic,*valdic;
    NSMutableArray *ary,*arrry;
    UIButton *btn ;
    NSString *a;
}
- (id)initWithFrame:(CGRect)frame withTitle:(NSMutableDictionary *)data;

- (NSMutableDictionary *) getValue;

@property (nonatomic, retain) id <danxuanDelegate> delegate;

@end
