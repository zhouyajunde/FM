//
//  wenjuanViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "danxuanView.h"
#import "duoxuanView.h"
#import "wendaView.h"

@interface wenjuanViewController : UIViewController<UIScrollViewDelegate,danxuanDelegate>{
    
    UIScrollView  *scrollView;
    NSArray * detailArray;
    danxuanView *item;
    duoxuanView *item1;
    wendaView *item2;
    wendaView *item3;
    NSMutableArray *arry;

}


@property(nonatomic ,strong)NSString *sjid;


@end
