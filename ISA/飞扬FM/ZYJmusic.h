//
//  ZYJmusic.h
//  01-ItcastLottery
//
//  Created by Mac os on 16/2/17.
//  Copyright © 2016年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@class scModel;
@protocol openDetegate <NSObject>

-(void)touch:(UIViewController *)con;

@end

@interface ZYJmusic : UIView


@property(nonatomic,assign)id delegate;


@end
