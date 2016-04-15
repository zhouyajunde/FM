//
//  duoxuanView.h
//  飞扬FM
//
//  Created by Mac os on 15/12/21.
//  Copyright © 2015年 SFware. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol duoxuanDelegate <NSObject>

-(void)newmess:(NSDictionary *)dic;

@end


@interface duoxuanView : UIView{
    
    UILabel *title ;
    
    NSMutableDictionary *timu,*valdic;
    
    NSMutableArray *btns;
}
- (id)initWithFrame:(CGRect)frame;

- (void)withTitle:(NSMutableDictionary *)data;



- (NSMutableDictionary *) getValue;

@property (nonatomic, retain) id <duoxuanDelegate> delegate;
@end
