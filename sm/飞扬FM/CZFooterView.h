//
//  CZFooterView.h
//  A01-团购
//
//  Created by Apple on 14/12/19.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol logOutDelegate <NSObject>

-(void)tuichu;

@end


@interface CZFooterView : UIView



@property(nonatomic,assign) id <logOutDelegate>delegate;

+ (instancetype)footerView;
@end
