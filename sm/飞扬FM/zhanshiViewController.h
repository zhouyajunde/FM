//
//  zhanshiViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/21.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface zhanshiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
     NSMutableArray *_editArray;
}


@property (nonatomic, weak, readonly) UITableView *tableView;

@end
