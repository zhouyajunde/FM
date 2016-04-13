//
//  ZYJchangjian.h
//  飞扬FM
//
//  Created by Mac os on 16/1/22.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYJchangjian : UIViewController<UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *_allGroups;
    int times;
}
@property (nonatomic, weak, readonly) UITableView *tableView;

@end
