//
//  ZYJShowCell.h
//  飞扬FM
//
//  Created by Mac os on 16/1/19.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZYJShowItem;

@interface ZYJShowCell : UITableViewCell

@property (nonatomic, strong) ZYJShowItem *item;
@property (nonatomic, strong) NSIndexPath *indexPath;

+ (instancetype)settingCellWithTableView:(UITableView *)tableView;
@end
