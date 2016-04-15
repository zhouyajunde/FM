//
//  ZYJbaseyinzhiController.h
//  飞扬FM
//
//  Created by Mac os on 16/1/25.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJShowGroup.h"

@interface ZYJbaseyinzhiController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
@property (nonatomic, weak, readonly) UITableView *tableView;

@property  (nonatomic, weak) UIView *view;



@end
