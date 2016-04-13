//
//  SIChannelListViewController.h
//  SIrico-FlyRadio
//
//  Created by Jin on 3/1/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SISuperViewController.h"
#import "MyPageLoadingView.h"

@interface SIChannelListViewController : SISuperViewController<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * myTableView;
	NSMutableArray *dataArray;
    
    MyPageLoadingView * loadingView;
    
    NSMutableArray * collectDataArray;
    
    UILabel * tipLabel;

}


- (id)initWithTidOrAid:(NSString *)cid channelType:(ChannelType)type;


@end
