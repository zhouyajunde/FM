//
//  ZYJPerCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/20.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYJItem;

@interface ZYJPerCell : UITableViewCell


@property (nonatomic, strong) ZYJItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)settingCellWithTableView:(UITableView *)tableView;

@end
