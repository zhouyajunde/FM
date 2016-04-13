//
//  tuijianViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreViewController.h"

@protocol tuijianDelegate <NSObject>

-(void)TomoreView:(UIViewController *)tuijianview;

-(void)MusicView:(UIViewController *)tuijianview;

@end


@interface tuijianViewController : UIViewController

@property(nonatomic,strong)NSMutableArray *topDataArray;

@property(nonatomic,assign)id delegate;

@end
