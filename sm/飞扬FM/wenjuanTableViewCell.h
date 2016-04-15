//
//  wenjuanTableViewCell.h
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "wenModel.h"

@interface wenjuanTableViewCell : UITableViewCell


@property(nonatomic,strong)wenModel *model;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;
@end
