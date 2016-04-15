//
//  bianjiView.h
//  飞扬FM
//
//  Created by Mac os on 16/3/1.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol editDetegate <NSObject>

-(void)all;

-(void)deleteEdit;

@end

@interface bianjiView : UIView

@property (weak, nonatomic) IBOutlet UIButton *quanxuanBtn;
@property (weak, nonatomic) IBOutlet UILabel *labText;

@property(nonatomic,assign)id delegate;
+(instancetype)init;
@end
