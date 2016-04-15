//
//  ZYJPViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ZYJPViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
@property (nonatomic, weak, readonly) UITableView *tableView;

@property  (nonatomic, weak) UIView *view;
@end
