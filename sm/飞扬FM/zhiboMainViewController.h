//
//  zhiboMainViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/27.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhiboMainViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups;
    
}


@property (nonatomic, weak, readonly) UITableView *tableView;
@end
