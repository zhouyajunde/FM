//
//  ZYJFooterView.h
//  飞扬FM
//
//  Created by Mac os on 16/3/2.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol wanchengDelegate <NSObject>

-(void)tuichude;

@end

@interface ZYJFooterView : UIView

@property(nonatomic,assign) id <wanchengDelegate>delegate;

+ (instancetype)footerView;
@end
