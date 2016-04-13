//
//  oneViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/12.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BFSegmentControl.h"
#import "BFSegmentItem.h"
#import "tuijianViewController.h"
#import "fenleiViewController.h"
#import "fenleiTabView.h"

@interface oneViewController : UIViewController<BFSegmentControlDataSource,UIScrollViewDelegate,tuijianDelegate,fenleiDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    
    BFSegmentItem *bfSegment;
    UIPageControl *pageControl;
    NSArray *testArray;
    UIScrollView *mainScrollView;

    
}
@property (nonatomic,strong)BFSegmentControl *testSegment;
@property (nonatomic,strong)tuijianViewController *tuijian;
@property (nonatomic,strong)fenleiViewController *fenlei;
@property (nonatomic,strong)fenleiTabView *fenleitTab;

@end
