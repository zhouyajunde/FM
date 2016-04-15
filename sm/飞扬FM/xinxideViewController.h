//
//  xinxideViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/2/24.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYJpersonImg.h"
#import "ZYJpersonMessage.h"
#import "ZYJShowGroup.h"
#import "ZYJShowArrowitem.h"

@interface xinxideViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}
@property (nonatomic, strong) UITableView *tableView;
@property  (nonatomic, weak) UIView *view;


@end
