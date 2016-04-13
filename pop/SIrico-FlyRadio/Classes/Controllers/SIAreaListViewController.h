//
//  SIAreaListViewController.h
//  SIrico-FlyRadio
//
//  Created by bjsmit01 on 14-3-25.
//  Copyright (c) 2014年 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISuperViewController.h"
#import "MyPageLoadingView.h"

@interface SIAreaListViewController : SISuperViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
	NSMutableArray *dataArray;
    
    MyPageLoadingView * loadingView;
    
}

- (id)initWithChannelType:(ChannelType)type;

@end
