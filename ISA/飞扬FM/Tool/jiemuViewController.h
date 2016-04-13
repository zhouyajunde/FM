//
//  jiemuViewController.h
//  飞扬FM
//
//  Created by Mac os on 16/2/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface jiemuViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *_allGroups; // 所有的组模型
}

@property (nonatomic,strong) NSMutableArray *_alljiemu;
@property (nonatomic,strong) NSData *timeMn;
@property (nonatomic, strong) UITableView *tableView;

@end
