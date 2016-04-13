//
//  changjianCell.h
//  飞扬FM
//
//  Created by Mac os on 16/2/29.
//  Copyright © 2016年 Mac os. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "changjianModel.h"

@interface changjianCell : UITableViewCell


@property(nonatomic,strong)changjianModel *model;

+(instancetype)shoucangCellWithTabView:(UITableView*)tableView;

@end
